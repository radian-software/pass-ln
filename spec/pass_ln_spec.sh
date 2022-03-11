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
    "pointing to a file" target symlink
    "pointing to a directory" example.com/target example.org/target example.com example.org
    "inside a subdirectory" example.com/target example.com/symlink
    "into a subdirectory from the top level" example.com/target symlink
    "into a subdirectory from another subdirectory" example.com/target example.org/symlink
    "into the top level from a subdirectory" target example.com/symlink
  End
  run() {
    pass insert -e "$2" <<< foobar
    pass ln "${4:-$2}" "${5:-$3}"
    pass "$3" | sed 's/^/result: /'
  }
  It "$1"
    When call run "$@"
    The output should include "Alias ${4:-$2} to ${5:-$3}."
    The output should include "result: foobar"
  End
End

Describe "overwriting an existing"
  Parameters
    "file at the top level" target symlink
    "directory at the top level" example.com/target example.org/symlink example.com example.org
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
