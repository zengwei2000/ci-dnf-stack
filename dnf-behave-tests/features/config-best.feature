Feature: Config option: best


Scenario: Verify that repo priorities work
  Given I use the repository "dnf-ci-fedora"
  Given I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "install glibc --setopt=dnf-ci-fedora.priority=90 --setopt=best=0"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                               |
        | install       | glibc-0:2.28-9.fc29.x86_64            |
        | install       | glibc-common-0:2.28-9.fc29.x86_64     |
        | install       | glibc-all-langpacks-0:2.28-9.fc29.x86_64      |
        | install       | basesystem-0:11-6.fc29.noarch         |
        | install       | filesystem-0:3.9-2.fc29.x86_64        |
        | install       | setup-0:2.12.1-1.fc29.noarch          |


Scenario: When priority repo is broken and best=0, install a package from repo with lower priority
  Given I use the repository "dnf-ci-fedora"
  Given I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "install glibc --setopt=dnf-ci-fedora.priority=90 --setopt=best=0 -x glibc-common-0:2.28-9.fc29.x86_64"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                               |
        | install       | glibc-0:2.28-26.fc29.x86_64           |
        | install       | glibc-common-0:2.28-26.fc29.x86_64    |
        | install       | glibc-all-langpacks-0:2.28-26.fc29.x86_64     |
        | install       | basesystem-0:11-6.fc29.noarch         |
        | install       | filesystem-0:3.9-2.fc29.x86_64        |
        | install       | setup-0:2.12.1-1.fc29.noarch          |
        | broken        | glibc-0:2.28-9.fc29.x86_64            |


Scenario: When installing with best=1, fail on broken packages
  Given I use the repository "dnf-ci-fedora"
  Given I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "install glibc --setopt=best=1 -x glibc-common-0:2.28-26.fc29.x86_64"
   Then the exit code is 1


Scenario: When upgrading with best=0, only report broken packages
  Given I use the repository "dnf-ci-fedora"
   When I execute dnf with args "install glibc"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                               |
        | install       | glibc-0:2.28-9.fc29.x86_64            |
        | install       | glibc-common-0:2.28-9.fc29.x86_64     |
        | install       | glibc-all-langpacks-0:2.28-9.fc29.x86_64      |
        | install       | basesystem-0:11-6.fc29.noarch         |
        | install       | filesystem-0:3.9-2.fc29.x86_64        |
        | install       | setup-0:2.12.1-1.fc29.noarch          |
  Given I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "upgrade -x glibc-common-0:2.28-26.fc29.x86_64"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                               |
        | broken        | glibc-0:2.28-26.fc29.x86_64           |
        | broken        | glibc-all-langpacks-0:2.28-26.fc29.x86_64     |


Scenario: When upgrading with best=1, fail on broken packages
  Given I use the repository "dnf-ci-fedora"
   When I execute dnf with args "install glibc"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                               |
        | install       | glibc-0:2.28-9.fc29.x86_64            |
        | install       | glibc-common-0:2.28-9.fc29.x86_64     |
        | install       | glibc-all-langpacks-0:2.28-9.fc29.x86_64      |
        | install       | basesystem-0:11-6.fc29.noarch         |
        | install       | filesystem-0:3.9-2.fc29.x86_64        |
        | install       | setup-0:2.12.1-1.fc29.noarch          |
  Given I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "upgrade -x glibc-common-0:2.28-26.fc29.x86_64 --best"
   Then the exit code is 1