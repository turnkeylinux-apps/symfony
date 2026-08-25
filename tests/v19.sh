#!/bin/bash
set -euo pipefail

APP_ROOT=/var/www/symfony
SOURCE_FILE=/usr/local/share/turnkey-symfony/source

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

require_contains() {
    local text=$1
    local expected=$2
    local context=$3
    [[ $text == *"$expected"* ]] || fail "$context did not contain: $expected"
}

[[ -r $SOURCE_FILE ]] || fail "source provenance record is missing"
[[ -x /usr/local/bin/turnkey-symfony ]] || fail "Symfony console helper is not executable"
[[ -x /usr/local/bin/turnkey-symfony-update ]] || fail "Symfony updater is not executable"
. "$SOURCE_FILE"

[[ $skeleton_version = 7.4.99 ]] || fail "unexpected skeleton version"
[[ $skeleton_commit = bf1abda299403468285fd4fa0514d916991c9120 ]] \
    || fail "unexpected skeleton commit"
[[ $skeleton_sha256 = 9dae378ef8e120b2763dd4879c9bb6ecae44592b3be156f3e130c72cc05a266d ]] \
    || fail "unexpected skeleton archive digest"
[[ $framework_version =~ ^7\.4\.[0-9]+$ ]] || fail "invalid framework version"
[[ $framework_commit =~ ^[0-9a-f]{40}$ ]] || fail "invalid framework commit"

runtime_version=$(cd "$APP_ROOT" && php -r \
    'require "vendor/autoload.php"; echo Symfony\Component\HttpKernel\Kernel::VERSION;')
[[ $runtime_version = "$framework_version" ]] || fail "runtime version differs from provenance"

lock_commit=$(php -r '
    $lock = json_decode(file_get_contents($argv[1]), true, 512, JSON_THROW_ON_ERROR);
    foreach ($lock["packages"] as $package) {
        if ($package["name"] === "symfony/framework-bundle") {
            echo $package["source"]["reference"];
            exit;
        }
    }
    exit(1);
' "$APP_ROOT/composer.lock")
[[ $lock_commit = "$framework_commit" ]] || fail "Composer lock differs from provenance"
[[ $(sha256sum "$APP_ROOT/composer.lock" | awk '{print $1}') = "$composer_lock_sha256" ]] \
    || fail "Composer lock digest differs from provenance"
[[ $(stat -c '%U:%G:%a' "$APP_ROOT/.env.local") = root:www-data:640 ]] \
    || fail "Symfony credential file permissions are incorrect"

console_output=$(turnkey-symfony about --env=prod --no-debug --no-ansi)
require_contains "$console_output" "Version" "Symfony console"
require_contains "$console_output" "${framework_version}" "Symfony console"
require_contains "$console_output" "Environment" "Symfony console"
require_contains "$console_output" "prod" "Symfony console"

db_output=$(turnkey-symfony dbal:run-sql \
    'SELECT message FROM turnkey_status WHERE id = 1' \
    --env=prod --no-debug --no-ansi)
require_contains "$db_output" "Database connectivity verified" "Doctrine DBAL console query"
direct_db=$(mysql --batch --skip-column-names symfony \
    --execute='SELECT message FROM turnkey_status WHERE id = 1')
[[ $direct_db = "Database connectivity verified" ]] || fail "direct MariaDB query failed"

apache2ctl configtest 2>&1 | grep -q 'Syntax OK' || fail "Apache configuration is invalid"
[[ -L /etc/apache2/sites-enabled/symfony.conf ]] || fail "Symfony Apache site is not enabled"
grep -q 'DocumentRoot /var/www/symfony/public' \
    /etc/apache2/sites-available/symfony.conf || fail "Symfony document root is incorrect"

page=$(curl -fsSL --max-time 20 http://127.0.0.1/)
require_contains "$page" "TurnKey Symfony" "sample application"
require_contains "$page" "Symfony ${framework_version} LTS sample application" "sample application"
require_contains "$page" "Database connectivity verified" "sample application DB query"

check_output=$(turnkey-symfony-update --check)
latest=$(awk -F= '$1 == "latest" { print $2 }' <<<"$check_output")
candidate=$(awk -F= '$1 == "candidate" { print $2 }' <<<"$check_output")
tag=$(awk -F= '$1 == "tag" { print $2 }' <<<"$check_output")
[[ $latest =~ ^7\.4\.[0-9]+$ ]] || fail "updater returned an invalid LTS patch"
[[ $candidate =~ ^[0-9a-f]{40}$ ]] || fail "updater returned an invalid candidate commit"
[[ $tag = "v$latest" ]] || fail "updater tag and version differ"
require_contains "$check_output" "channel=official-7.4-lts" "updater check"

apply_plan=$(turnkey-symfony-update --apply --dry-run)
require_contains "$apply_plan" "mode=apply-dry-run" "updater apply plan"
require_contains "$apply_plan" "target=$latest" "updater apply plan"
require_contains "$apply_plan" "candidate=$candidate" "updater apply plan"
require_contains "$apply_plan" "tag=v$latest" "updater apply plan"
require_contains "$apply_plan" "verified=official-framework-bundle-tag" "updater apply plan"

echo "PASS: sample app, MariaDB, Symfony console, Apache, provenance, and updater"
echo "framework=$framework_version framework_commit=$framework_commit"
echo "updater_target=$latest updater_candidate=$candidate"
cat > /run/tkl-v19-tests/result.txt <<EOF
verdict=PASS
product=symfony
framework=$framework_version
framework_commit=$framework_commit
updater_target=$latest
updater_candidate=$candidate
EOF
