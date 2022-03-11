before_all() {
  REPO_DIR="${PWD}"
  pushd "${SHELLSPEC_WORKDIR}"
  export HOME="${PWD}"

  %text > batch.gpg
  #|Key-Type: RSA
  #|Key-Length: 2048
  #|Subkey-Type: RSA
  #|Subkey-Length: 2048
  #|Name-Real: pass-ln testing
  #|Name-Email: pass-ln-testing@example.com
  #|Expire-Date: 1d
  #|%no-protection
  #|%commit

  gpg --batch --gen-key batch.gpg 2>&1

  git config --global user.name "pass-ln testing"
  git config --global user.email pass-ln-testing@example.com
  git config --global init.defaultBranch main
}

before_each() {
  pass init pass-ln-testing
  pass git init

  export PASSWORD_STORE_ENABLE_EXTENSIONS=true
  mkdir -p "${HOME}/.password-store/.extensions"
  ln -s "${REPO_DIR}/pass-ln.bash" "${HOME}/.password-store/.extensions/ln.bash"
}

after_each() {
  rm -rf .password-store
}

after_all() {
  popd
}

BeforeAll before_all
AfterAll after_all

BeforeEach before_each
AfterEach after_each

Describe "creating a symlink"
  Parameters
    # 1 - name of test
    # 2 - target of symlink (real path)
    # 3 - link name (real path)
    # 4 - target of symlink (passed to pass ln) - defaults to 2
    # 5 - link name (passed to pass ln) - defaults to 3
    # 6 - link name (expected in commit message) - defaults to 5
    "pointing to a file" target symlink
    "pointing to a directory" example.com/target example.org/target example.com example.org
    "inside a subdirectory" example.com/target example.com/symlink
    "into a subdirectory from the top level" example.com/target symlink
    "into a subdirectory from another subdirectory" example.com/target example.org/symlink
    "into the top level from a subdirectory" target example.com/symlink
    "with a trailing slash from the top level" target example.com/target target example.com/ example.com/target
    "with a trailing slash from another subdirectory" example.com/target example.org/target example.com/target example.org/ example.org/target
  End
  run() {
    pass insert -e "$2" <<< foobar
    pass ln "${4:-$2}" "${5:-$3}"
    pass "$3" | sed 's/^/result: /'
  }
  It "$1"
    When call run "$@"
    The output should include "Alias ${4:-$2} to ${6:-${5:-$3}}."
    The output should include "result: foobar"
  End
End

Describe "overwriting an existing"
  Parameters
    # 1 - name of test
    # 2 - target of symlink (real path)
    # 3 - attempted link name that already exists (real path)
    # 4 - target of symlink (passed to pass ln) - defaults to 2
    # 5 - attempted link name (passed to pass ln) - defaults to 3
    "file at the top level" target symlink
    "directory at the top level" example.com/target example.org/symlink example.com example.org
    "file in a subdirectory" example.com/target example.com/symlink
    "file in a subdirectory from the top level" target example.com/symlink
    "subdirectory" example.com/subdir/foo example.com/elsewhere/bar example.com/subdir example.com/elsewhere
  End
  run() {
    pass insert -e "$2" <<< foobar
    pass insert -e "$3" <<< bigbad
    pass ln "${4:-$2}" "${5:-$3}" 2>&1
  }
  It "$1"
    When call run "$@"
    The status should be failure
    The output should include "refusing to overwrite"
    The output should not include "Alias"
  End
End

Describe "conflicts do not occur"
  Parameters
    # 1 - name of test
    # 2 - potentially conflicting file to create
    # 3 - target of symlink (real path)
    # 4 - link name (real path)
    # 5 - target of symlink (passed to pass ln) - defaults to 3
    # 6 - link name (passed to pass ln) - defaults to 4
    # 7 - link name (expected in commit message) - defaults to 6
    "when creating a file next to a directory" ambiguous/foobar target ambiguous
    "when creating a directory next to a file" ambiguous target ambiguous/foobar
    "when creating a file next to a directory with trailing slash" parent/ambiguous/foobar ambiguous parent/ambiguous ambiguous parent/ parent/ambiguous
    "when creating a directory next to a file with trailing slash" parent/ambiguous ambiguous/foobar parent/ambiguous/foobar ambiguous parent/ parent/ambiguous
  End
  run() {
    pass insert -e "$3" <<< foobar
    pass insert -e "$2" <<< bigbad
    pass ln "${5:-$3}" "${6:-$4}"
    pass "$4" | sed 's/^/result: /'
  }
  It "$1"
    When call run "$@"
    The output should include "Alias ${5:-$3} to ${7:-${6:-$4}}."
    The output should include "result: foobar"
  End
End
