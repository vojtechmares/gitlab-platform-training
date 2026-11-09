<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable-next-line MD041 -->
<p align="center">
  <h1 align="center" style="font-size: 4rem;">GitLab Platform Training</h1>
  <p align="center" style="font-size: 1.5rem;">
    Git, GitLab, CI/CD and security in practice: work as a team, ship with confidence, and be able to prove it.
  </p>
  <p align="center">
    <a href="https://about.gitlab.com/"><img alt="GitLab" src="https://img.shields.io/badge/TRAINING ON-GITLAB-FC6D26?style=for-the-badge"></a>
    <a href="https://www.mares.cz"><img alt="Vojtěch Mareš" src="https://img.shields.io/badge/TRAINING BY-Vojtěch Mareš-fd9a00?style=for-the-badge"></a>
  </p>
  <p align="center"><a href="https://www.mares.cz">Vojtěch Mareš</a> | <a href="mailto:vojtech@mares.cz">vojtech@mares.cz</a></p>
</p>
<!-- markdownlint-enable MD033 -->

## About the course

A two-day, hands-on course for people who **use GitLab**: Git properly, GitLab itself, working as a team (merge requests, **CODEOWNERS**, and how it all becomes audit evidence for **SOC 2 Type II**), registries and security scanning, CI/CD with practical examples, and practical security guides. A ninth chapter is for the people who **own the platform**: locking down the instance, user management, required approvals at scale, and reporting.

**Audience:** developers, team leads, QA and DevOps engineers with a little Git experience (clone, commit, push). Chapter 9 adds administrators, security and compliance.

**Every GitLab feature is marked with the tier it needs**, and the claims are checked against the documentation of **GitLab 19.5**:

🟢 **Free**: available in every tier · 🟣 **Premium**: Premium **and** Ultimate · 🟠 **Ultimate**: Ultimate only

Each section links to the official documentation as `[Docs](...)`. The links point at the **19.5** version of docs.gitlab.com; replace `19.5` in the URL with your version, and re-read the `Tier:` line of a page before you rely on a feature (tiers change between releases). The list of features with their tiers is [Appendix C](#appendix-c-tier-reference).

### Contents

| Chapter | Topic | Day |
| --- | --- | --- |
| [0](#chapter-0-setup) | Setup | - |
| [1](#chapter-1-git-fundamentals-part-1) | Git fundamentals, part 1: how Git thinks, first repository, remotes | 1 |
| [2](#chapter-2-git-fundamentals-part-2) | Git fundamentals, part 2: merge, rebase, undo, recover | 1 |
| [3](#chapter-3-gitlab-for-users) | GitLab for users: groups, roles, planning, tiers | 1 |
| [4](#chapter-4-team-collaboration) | Team collaboration: merge requests, approvals, **CODEOWNERS**, audit evidence, SOC 2 | 1 |
| [5](#chapter-5-registries-releases-and-security-scanning) | Registries, releases and security scanning | 2 |
| [6](#chapter-6-cicd-fundamentals) | CI/CD fundamentals | 2 |
| [7](#chapter-7-ci-in-practice) | CI in practice: rules, reuse, build and deploy | 2 |
| [8](#chapter-8-security-in-practice) | Security in practice: secrets, hardening, scanners | 2 |
| [9](#chapter-9-governance-for-platform-owners) | Governance for platform owners: instance, identity, approvals at scale, reporting | extra |
| [A-D](#appendix-a-git-cheat-sheet) | Cheat sheets, tier reference, pipeline review checklist | - |

The CI examples referenced in the chapters live in [`examples/`](examples/): pipelines in [`examples/ci/`](examples/ci/) (one file per step, plus [components](examples/ci/components/)), the Git practice scenarios in [`examples/git-exercises/`](examples/git-exercises/), a sample [`CODEOWNERS`](examples/codeowners/CODEOWNERS) and the sample application in [`examples/hello-app/`](examples/hello-app/).

### Agenda

<a id="agenda"></a>

Two days, 09:00 to 17:00, in 90-minute blocks, each followed by a break and ending with a hands-on part on a lab instance. Net teaching time is **6 hours a day**; the last 30 minutes are a buffer.

| Time | Day 1 | Day 2 |
| --- | --- | --- |
| 09:00 - 10:30 | Chapter 1: Git fundamentals I | Chapter 5: Registries, releases, scanning |
| 10:45 - 12:15 | Chapter 2: Git fundamentals II | Chapter 6: CI/CD fundamentals |
| 12:15 - 13:15 | Lunch | Lunch |
| 13:15 - 14:45 | Chapter 3: GitLab for users | Chapter 7: CI in practice |
| 15:00 - 16:30 | Chapter 4: Team collaboration, CODEOWNERS, audit | Chapter 8: Security in practice |
| 16:30 - 17:00 | Recap, questions | Recap, questions |

**Governance (Chapter 9) does not fit into those two days.** Choose one:

1. **A third half-day** (90 to 120 minutes) for platform owners, security and compliance, on its own date
2. **The 8-hour variant**: if "2 x 8 hours" means eight *net* hours, add one 90-minute block per day. On Day 2, run Chapter 9 in place of the optional CI clinic; on Day 1 keep the workshop on the team's real working agreement and CODEOWNERS
3. **Callouts only**: for a developers-only group skip Chapter 9 and read only the **For owners and admins** notes in Chapters 1 to 8

If time runs short, cut in this order: push rules and signed commits (Chapter 4, show only), `bisect` and `cherry-pick` (Chapter 2), Dependency Proxy, packages and releases (Chapter 5), `matrix` and `needs` (Chapter 7), steps 7 and 8 of the Chapter 3 and 4 hands-on (the trainer shows them). **Never cut**: the Git rescue hands-on, the permission matrix, "prove the gate", the first pipeline, the deploy, and the review of an inherited pipeline.

### How to run it

- Start each chapter by naming the question it answers and end it by asking what they would change in their own project on Monday. Keep a parking lot for questions about the participants' own pipelines
- Chapter 1: write the participants' fears about Git on a flip chart ("I broke the repo", "conflicts", "I lost my work") and tick them off in Chapter 2
- Chapter 3: ask which tier the company has and write it down; never say "GitLab can do X" without the marker
- Chapter 4: say once, out loud, that the SOC 2 part is an engineering view and not audit advice
- Hands-on parts: walk around, do not narrate; when something fails, **read the log out loud**, diagnosis is the skill
- After the Chapter 4 hands-on the participants' forks have approval gates on `main`; step 8 there relaxes them so people can merge their own work later. Check at the start of Chapter 6 that they did
- The lab instance, its accounts and how to build it: [`infrastructure/README.md`](infrastructure/README.md), with `scripts/seed-training-data.sh` for the accounts and sample projects. Premium and Ultimate steps need a trial or licence on the instance; without it the trainer shows them on screen

### Contribute

The course is forever open-source, so feel free to fork, create issues, contribute or just download the materials.

## About the lector

Hi 👋, I'm Vojtěch Mareš and I will be your lector. I am a freelance DevOps architect, consultant and lector. I work with clients to improve their systems with

- CI pipelines
- Containerization with Docker
- Application orchestration on Kubernetes
- Observability with Prometheus, Grafana, Loki and Open Telemetry
- Infrastructure either on cloud or on-premise managed with Terraform
- I work with: Git, Kubernetes, Terraform, GitHub, GitLab, Prometheus, Grafana, Docker, PostgreSQL, and [more](https://www.mares.cz/en/services)...

---

## Chapter 0: Setup

[Docs: install Git](https://git-scm.com/downloads) · [GitLab SSH keys](https://docs.gitlab.com/19.5/user/ssh/)

What a participant needs. Send this to them a few days ahead.

- A laptop with a browser, **Git 2.30 or newer**, and an **SSH client**
- **Windows**: install Git for Windows and use **Git Bash**. The practice scripts do not run in PowerShell or `cmd` (WSL works)
- **Outbound access to the lab instance** on ports **443** (web) **and 22** (Git over SSH). Many corporate networks block outgoing 22; the Chapter 1 hands-on shows Git over HTTPS with a token as the fallback. Test `ssh -T git@<gitlab-host>` the day before: it should reach GitLab even though it fails to log in
- **Docker or Podman** is useful for the Chapter 5 hands-on (push an image). Without it, follow that step on the trainer's screen
- No account setup: the trainer creates the accounts (`trainee1`, `trainee2`, ... and the personas `alice`, `bob`, `carol`, `dave`)

```bash
git --version                    # 2.30 or newer
ssh -V
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

How to read this document:

| You see | It means |
| --- | --- |
| 🟢 Free, 🟣 Premium, 🟠 Ultimate | The tier a feature needs (Premium means Premium and Ultimate) |
| `[Docs](...)` | The official documentation of the section, for GitLab 19.5 |
| `> [!NOTE]`, `[!TIP]`, `[!WARNING]`, `[!IMPORTANT]` | Side notes. **For owners and admins** notes point out what a platform owner controls |
| **Hands-on** | A guided exercise at the end of a chapter, with time estimates |
| `<details>` blocks | Answers, kept closed so you can try first |

---

## Chapter 1: Git fundamentals, part 1

How Git thinks, your first repository, and talking to a remote. All of this is plain Git, so there are no tier labels yet.

### Git in one picture

[Docs](https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F)

- **Distributed**: every clone has the **whole history**. Your laptop is a complete copy, not a window onto a server
- A **commit is a snapshot** of the whole project at one moment, not a list of changes. Git computes differences when you ask. That is why branching is cheap and why rewriting history creates **new** commits
- A commit knows its **parent(s)**, so history is a chain (a graph)
- Almost everything is **local and fast**: commit, branch, diff and log need no network
- A server (GitLab) is just **another copy** everyone agrees to treat as the shared one

```text
 A ◀── B ◀── C ◀── D        each letter = a commit; arrows point to the parent
```

### The three areas

[Docs](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository)

```text
  working tree          index (staging area)        repository (.git)
  files you edit   ──▶  what the next commit    ──▶  commits, forever
                  git add      will contain   git commit
        ◀────────────────────────────────────────────
              git restore             git restore --staged
```

| Command | Compares |
| --- | --- |
| `git diff` | working tree **vs** index (changes not yet staged) |
| `git diff --staged` | index **vs** last commit (what you are about to commit) |
| `git diff HEAD` | working tree **vs** last commit (everything) |
| `git status` | summarises all three |

Staging lets you build a **clean commit** out of a messy working tree.

### Setup that avoids surprises

[Docs](https://git-scm.com/docs/git-config)

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true      # first push sets the upstream for you
git config --global fetch.prune true               # forget branches deleted on the server
```

Where a setting comes from matters. The narrowest scope wins:

| Scope | File | Wins over |
| --- | --- | --- |
| system | `/etc/gitconfig` | nothing |
| **global** | `~/.gitconfig` | system |
| **local** | `.git/config` of one repository | global |

```bash
git config --list --show-origin       # every setting and the file it came from
```

A few settings change behaviour and explain "it works differently on my laptop":

| Setting | Effect |
| --- | --- |
| `merge.ff = only` | `git merge` refuses anything that is not a fast-forward ("Not possible to fast-forward, aborting") |
| `pull.rebase = true` | `git pull` rebases instead of merging |
| `core.autocrlf` | line-ending conversion (Windows) |
| `commit.gpgsign = true` | sign every commit |

> [!TIP]
> When a colleague's Git behaves differently from the example, run `git config --list --show-origin` before anything else.

### A first repository

[Docs](https://git-scm.com/docs/git-init)

```bash
git init demo && cd demo
echo "# demo" > README.md
git status                     # README.md is untracked
git add README.md
git commit -m "Add README"
git log --oneline
```

```text
a3f9c21 Add README
```

- **`git status`** is the command to run when you are unsure. Run it often
- `git commit -m` for short messages; plain `git commit` opens your editor for a longer one
- The short id (`a3f9c21`) is the first characters of the commit's hash

### What a commit is

```text
commit  a3f9c21...            <- id: a hash of everything below
tree    9b2e...               <- the snapshot of the whole project
parent  7d0c...               <- the commit before (two for a merge, none for the first)
author  Ada <ada@example.com> 2026-11-08 10:15
committer ...

Add README
```

Change **anything** (the content, the message, the parent) and you get a **different id**. So "editing a commit" really means *making a new commit and moving a label to it*. This is why rewriting history needs care once others have your commits (Chapter 2).

### Reading history

[Docs](https://git-scm.com/docs/git-log)

```bash
git log --oneline --graph --all     # the shape of the repository
git show a3f9c21                    # one commit: message and changes
git show v1.0:cart.py               # a file as it was at a tag
git diff main..feature              # what feature has that main does not
git blame cart.py                   # who last changed each line
git log -S"total("                  # commits where the NUMBER of "total(" changed
git log --follow -p cart.py         # the history of one file, across renames
```

Questions these answer: **who** wrote this line, **when** did this function appear, **why** (the commit message and the issue it links to), **what else** changed with it. Good history is written for the person who debugs this at 2 am. Often that is you.

### Good commits

[Docs](https://www.conventionalcommits.org/en/v1.0.0/)

- **One purpose per commit.** If you need "and" in the subject, it is two commits
- **Subject**: imperative, about 50 characters, no full stop: *"Fix off-by-one in total()"*
- **Body** (optional, after a blank line): **why**, not what. The diff already shows what
- Reference the work: `Closes #123`
- Stage deliberately: `git add -p` picks hunks; `git commit -v` shows the diff while you write

**Conventional Commits** is a popular shape for the subject, `type(scope): subject`. Teams adopt it for a readable history, changelogs generated from commits, and a convention a reviewer can check:

```text
feat(cart): add discounted()
fix(cart): include the last item in total()
docs: explain the discount rule
```

### `.gitignore`

[Docs](https://git-scm.com/docs/gitignore)

Files Git should never track: build output, dependencies, editor files, logs and **secrets**.

```gitignore
# build output and dependencies
build/
node_modules/
__pycache__/
*.log

# local configuration and secrets - NEVER commit these
.env
*.pem

# but keep this one
!.env.example
```

```bash
git check-ignore -v .env           # which rule ignores this file?
git rm --cached .env               # stop tracking a file you committed by mistake
```

> [!WARNING]
> Ignoring comes too late for a secret that is already committed: **the value stays in history**. Chapter 8 covers what to do. Better: add `.env` to `.gitignore` in the first commit.

### Branches are pointers

[Docs](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)

```text
            main
              │
 A ◀── B ◀── C            a branch is a movable label on a commit
                \
                 D ◀── E
                       │
                  feature   <- HEAD points at the branch you are on
```

```bash
git switch -c feature        # create a branch and move to it
git branch                   # list; * marks the current one
git switch main              # move back
```

Creating a branch costs almost nothing: it is a small file holding a commit id. **HEAD** is "where you are"; new commits move the branch HEAD points at.

### Remotes

[Docs](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes)

```bash
git clone git@gitlab.example.com:team/app.git     # copy a repository and remember where from
git remote -v                                      # "origin" is the default name for that remote
git fetch                                          # download new commits, change NOTHING you are working on
git pull                                           # fetch, then merge (or rebase) into your branch
git push -u origin feature                         # upload; -u links your branch to the remote one
git status -sb                                     # "ahead 2, behind 1" tells you where you stand
```

`origin/main` is your **last known copy** of the server's `main`. It only moves when you `fetch`.

```text
 main          A ◀── B ◀── C               your branch
 origin/main   A ◀── B                     what the server had when you last fetched
```

> [!TIP]
> `git fetch` is always safe. `git pull` changes your branch, so know what it will do (`pull.rebase`).

### Authenticating to GitLab 🟢 Free

[SSH keys](https://docs.gitlab.com/19.5/user/ssh/) · [Personal access tokens](https://docs.gitlab.com/19.5/user/profile/personal_access_tokens/) · [Two-factor authentication](https://docs.gitlab.com/19.5/user/profile/account/two_factor_authentication/)

| Method | Setup | Use |
| --- | --- | --- |
| **SSH key** | `ssh-keygen -t ed25519`, paste the `.pub` file under *Edit profile > Access > SSH keys*, test with `ssh -T git@host` | Your laptop, day to day |
| **HTTPS + token** | A *personal access token* with the **smallest scope** that works (`read_repository`, `write_repository`), used as the password | Networks that block SSH, scripts |

- A password is not accepted for Git over HTTPS once 2FA is on: use a token
- Never paste a token into a repository, a ticket or a chat. Chapter 8 shows what happens when you do

> [!NOTE]
> **For owners and admins.** A commit's author name and e-mail are whatever the client typed: Git does not authenticate them. What proves who wrote a commit is a **signature**. *Verifying* signed commits (GPG, SSH, X.509) is 🟢 Free; *enforcing* them with push rules is 🟣 Premium (Chapter 9). SSH keys and tokens are credentials you can inventory, restrict and expire centrally: see Chapter 9.

### Hands-on: a practice repository and your first push

About 30 minutes. Everything here is 🟢 Free. You need Git 2.30 or newer, a terminal (on Windows: **Git Bash**), and the login the trainer gave you (`trainee1`, `trainee2`, ...). Goal: understand your Git setup, make commits on purpose, read a history to answer real questions, and push to GitLab.

#### 1. Know your settings (4 min)

```bash
git --version
git config --list --show-origin
```

1. Find `user.name` and `user.email`. Which file does each come from? Set them if they are missing (the e-mail of your GitLab account)
2. Look for `merge.ff` and `pull.rebase`. Do you have them set, and where? Write the answer down; it explains surprises later today

#### 2. Connect to GitLab with SSH (5 min)

```bash
ssh-keygen -t ed25519 -C "trainee1 training key"     # accept the defaults; a passphrase is a good idea
cat ~/.ssh/id_ed25519.pub
```

1. In GitLab: avatar, **Edit profile > Access > SSH keys > Add new key**, paste the *public* key
2. Test it with the host name from the GitLab address, without `https://`: `ssh -T git@<gitlab-host>`. Expected: `Welcome to GitLab, @trainee1!`
3. Get the practice scenarios (you need them again in Chapter 2):

   ```bash
   git clone git@<gitlab-host>:training/git-exercises.git
   ```

#### 3. Your first repository (8 min)

```bash
mkdir shop && cd shop
git init
echo "A tiny shop." > README.md
git status                            # what does Git say about the file?
git add README.md && git status       # what changed?
git commit -m "Add README"
echo "More text." >> README.md
git diff                              # the change, not staged
git add README.md
git diff --staged                     # the change, staged
git restore --staged README.md        # unstage it again
git restore README.md                 # throw the change away (no undo for this one)
```

1. Make two **separate** changes in two files and commit them as **two commits**. Try `git add -p` on a file with two edits
2. Add a `.gitignore` containing `*.log` and `.env`. Create `debug.log`. Does `git status` show it? Which rule ignores it? (`git check-ignore -v debug.log`)

#### 4. Read a history (8 min)

Build the **history** scenario and answer using only Git commands. Write the command next to each answer:

```bash
cd .. && bash git-exercises/history.sh practice-history && cd practice-history
```

1. How many commits are on `main`? Which branch is **not** merged? (`git log --oneline --graph --all`)
2. Who wrote the line `DISCOUNT = 0.1`? (`git blame cart.py`)
3. Which two commits dealt with a bug in `total()`? (`git log -S"prices[:-1]" --oneline`) What does the **message** of the first one claim, and was it true?
4. What did `cart.py` look like at the first release? (`git show v1.0:cart.py`)
5. What does `feature/export` contain that `main` does not? (`git diff main..feature/export`)

<details>
<summary>Answers</summary>

1. 8 commits on `main`; `feature/export` is not merged. 2. Alice. 3. The two commits found by `-S`; the first one claimed a fix that did not fix it. 4. `git show v1.0:cart.py` prints the file at the tag. 5. It adds `export.py`.

</details>

> [!NOTE]
> On Windows without Git Bash, run the scripts in WSL or ask the trainer for the ready-made repository.

#### 5. Push to GitLab, then fetch (7 min)

1. **Your work > Projects > New project > Create blank project**. Name `shop`, **Private**, **untick** *Initialize repository with a README*
2. In `shop`: `git remote add origin git@<gitlab-host>:trainee1/shop.git` and `git push -u origin main`
3. Find your commits under **Code > Commits**. Then `git status -sb` and `git remote -v`: what do they say about `origin/main`?
4. Clone the project again as `shop2`, commit and push there. Back in `shop`, `git status -sb` still says "up to date". Why? Then `git fetch`, `git log --oneline main..origin/main`, `git pull`

#### Check yourself

- [ ] You know which file each important Git setting comes from
- [ ] `ssh -T` greets you by name and your commits are in GitLab
- [ ] You can explain `git diff`, `git diff --staged` and `git diff HEAD`
- [ ] You can say why `git status` said "up to date" before the fetch

#### Questions to discuss

- A colleague's `git pull` creates merge commits and yours does not. Where do you look first?
- You committed `.env` yesterday and added it to `.gitignore` today. Is the secret safe? (No: it is in history.)
- SSH key or personal access token: when would you use each?

---

## Chapter 2: Git fundamentals, part 2

Branching, merging, rebasing, undoing, and getting your work back. Again plain Git; the GitLab counterparts are marked.

### Merging

[Docs](https://git-scm.com/docs/git-merge) · [GitLab merge methods](https://docs.gitlab.com/19.5/user/project/merge_requests/methods/) 🟢 Free

```text
 before:   A ◀── B ◀── C            main
                  \
                   D ◀── E          feature

 git switch main && git merge feature
```

| Situation | Result |
| --- | --- |
| `main` has not moved since `feature` started | **Fast-forward**: `main` just moves to `E`. No new commit |
| Both moved | A **merge commit** with two parents joins them |

```bash
git merge feature              # fast-forward if possible, else a merge commit
git merge --no-ff feature      # always a merge commit (keeps "this was a feature" visible)
git merge --abort              # leave a conflicted merge, back to before
```

GitLab offers the same choice as the project's **merge method**: merge commit, merge commit with semi-linear history, or fast-forward only.

### Conflicts

[Docs](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging#_basic_merge_conflicts)

A conflict is **not an error**. It is Git saying: *"both sides changed the same lines; you decide."*

```text
<<<<<<< HEAD
  replicas: 3
=======
  replicas: 4
>>>>>>> feature/scale
```

1. `git status` lists the files "both modified"
2. Open each file, decide the final content, **delete the markers**
3. `git add <file>` marks it resolved
4. `git commit` finishes the merge (or `git merge --continue`)

Conflicts happen when branches **live long** and **touch the same code**. Run the tests after resolving: a conflict resolved wrongly compiles fine and misbehaves. The panic button is `git merge --abort`.

### Rebase: replaying your commits

[Docs](https://git-scm.com/docs/git-rebase)

```text
 before:   A ◀── B ◀── C            main
                  \
                   D ◀── E          feature

 git switch feature && git rebase main

 after:    A ◀── B ◀── C            main
                        \
                         D' ◀── E'  feature     (new commits, same changes)
```

- `D'` and `E'` are **new commits** (different parent, so different ids). The old ones are abandoned
- Result: a **straight line** of history, no merge commit
- Conflicts can still occur, once per replayed commit: `git rebase --continue` / `--abort`

> [!WARNING]
> **Never rebase commits that other people already have.** Rebase your **own** branches. Rewriting shared history forces everyone else to untangle it.

| | Merge | Rebase |
| --- | --- | --- |
| History | Shows the real branching | Straight line |
| Safe on shared branches | **Yes** | **No** |
| Conflicts | Resolve once | Possibly per commit |
| Typical use | Bring a feature into `main` | Update **your own** branch from `main` |

A common team agreement: update your feature branch with `git pull --rebase` (it is yours), merge into `main` through a **merge request** (squash or merge commit, as the team decides), and never rebase `main` or any branch someone else works on. Decide once and write it down (Chapter 4).

> [!NOTE]
> **For owners and admins.** "Never rewrite shared history" does not have to rely on discipline: a **protected branch** (🟢 Free) rejects force pushes unless someone explicitly allows them. See [protected branches](https://docs.gitlab.com/19.5/user/project/repository/branches/protected/) and Chapter 4.

### Undoing: pick the right tool

[Docs](https://git-scm.com/docs/git-reset)

| I want to... | Command | Rewrites history? |
| --- | --- | --- |
| Throw away edits to a file (not staged) | `git restore file` | no (**edits are lost**) |
| Unstage a file | `git restore --staged file` | no |
| Fix the **last commit** (message or forgotten file) | `git commit --amend` | yes (last commit only) |
| Undo a commit that is **already pushed** | `git revert <commit>` | **no**: adds a new commit that cancels it |
| Throw away local commits, keep the changes | `git reset --soft HEAD~2` | yes (local) |
| Throw away local commits **and** changes | `git reset --hard HEAD~2` | yes, **dangerous** |
| Park unfinished work | `git stash push -u` then `git stash pop` | no |

Rule of thumb: **pushed and shared** means `revert`. **Local and unpushed** means `reset` or `amend`.

```text
 git reset --soft  HEAD~1     move the branch back; keep index and files   (changes staged)
 git reset --mixed HEAD~1     (default) also unstage                        (changes in the working tree)
 git reset --hard  HEAD~1     also discard the files                        (changes GONE)
```

`--hard` is the only mode that can destroy **uncommitted** work. Before a risky command: `git status`, and if in doubt `git stash` or `git branch backup`. In GitLab you can also [revert a merge request](https://docs.gitlab.com/19.5/user/project/merge_requests/revert_changes/) from the interface.

### The reflog: your safety net

[Docs](https://git-scm.com/docs/git-reflog)

Git records **every place HEAD has been** for about 90 days (30 for unreachable entries by default).

```bash
git reflog
```

```text
3c9e0a1 HEAD@{0}: reset: moving to HEAD~3
9fd2b7e HEAD@{1}: commit: Important work: line 6      <- the "lost" tip
2a41c55 HEAD@{2}: commit: Important work: line 5
```

```bash
git reset --hard HEAD@{1}              # go back to where you were
git branch rescue 9fd2b7e              # or just give the lost commit a name
```

- Recovers: a bad `reset --hard`, deleted branches, a rebase gone wrong, a bad `amend`
- Does **not** recover: **uncommitted** edits, files never added, another person's clone. It is **local** to your clone

> [!TIP]
> The habit: **commit often, even work in progress.** A commit can be recovered; an unsaved edit cannot.

### Clean up before others see it

[Docs](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

Your branch history is for **you** while you work. Before you open a merge request, make it tell a story.

```bash
git commit --fixup <commit>                  # "this belongs to that earlier commit"
git rebase -i --autosquash main              # reorder and fold them automatically
git push --force-with-lease                  # after rewriting YOUR pushed branch; refuses if someone else pushed. Never plain --force
```

| Todo word | Effect |
| --- | --- |
| `pick` | keep the commit |
| `reword` | keep it, change the message |
| `squash` / `fixup` | fold into the previous commit (squash keeps the message, fixup drops it) |
| `drop` | delete the commit |

### bisect and cherry-pick

[bisect](https://git-scm.com/docs/git-bisect) · [cherry-pick](https://git-scm.com/docs/git-cherry-pick)

**Find the commit that broke something** by halving the history (16 commits take about 4 steps):

```bash
git bisect start
git bisect bad                 # the current commit is broken
git bisect good v1.0           # this one worked
git bisect run ./test.sh       # Git tests the middle, halves again...
git bisect reset
```

**Copy one commit** to another branch, for example a hotfix to a release branch:

```bash
git switch release/1.0
git cherry-pick -x 9fd2b7e     # -x records where it came from in the message
```

Both rely on **small, well-described commits**. A giant "update everything" commit hides the bug.

### Secrets and big files in history

[GitLab: repository size and removing blobs](https://docs.gitlab.com/19.5/user/project/repository/repository_size/) · [Git LFS](https://docs.gitlab.com/19.5/topics/git/lfs/)

- Deleting a file in a new commit **does not remove it from history**
- A committed secret is **compromised**: **rotate it first**, then clean up
- Cleaning history (`git filter-repo`) rewrites every commit id and needs a team-wide re-clone. GitLab can help remove blobs on the server, but that is a last step, not the first
- Large binaries: **Git LFS**, or do not version them. History never shrinks by itself
- Prevention beats cure: `.gitignore` from the first commit, a **pre-commit** secret scan locally, and server-side scanning (Chapter 8)

### Hands-on: rescue scenarios

About 40 minutes, plain Git, 🟢 Free. Each scenario is a repository in a broken or awkward state; you fix it with real commands. Scenarios 1 to 3 are the core (about 8 minutes each), 4 and 5 are for the quick ones. The scripts are in [`examples/git-exercises/`](examples/git-exercises/); the lab instance has them as `training/git-exercises`.

Rules of the game:

- Build a scenario with `bash git-exercises/<name>.sh <folder>`. Running it again **rebuilds it from scratch**: that is your reset button
- Before something risky, bookmark: `git branch backup`. After **every** step look with `git status` and `git log --oneline --graph --all`
- Work from the folder **above** `git-exercises`. On Windows use Git Bash (the scripts do not work in PowerShell or `cmd`)

#### 1. conflict: two people changed the same line (8 min)

```bash
bash git-exercises/conflict.sh practice-conflict && cd practice-conflict
git merge feature/scale          # which file is in conflict? (git status)
```

`main` and `feature/scale` both changed the replicas in `config.yaml`. The team agreed on **3 replicas**, **`log_level: debug`** and the new **`region: eu`** line. Resolve it, delete **all** marker lines, `git add`, `git commit`. Then prove you can bail out: rebuild a fresh copy, start the merge and run `git merge --abort`.

**Done when:** no markers, the graph shows a merge commit with two parents, and you used `--abort` once.

#### 2. wrong-branch: you committed on main by mistake (8 min)

```bash
bash git-exercises/wrong-branch.sh practice-wrong-branch && cd practice-wrong-branch/work
```

Two unpushed commits sit on `main` but belong on a branch. **Goal:** `main` equals `origin/main` again and the two commits live on `feature/export`.

Hints: a branch is a label, so put a second label on the current commit **before** moving `main`; `origin/main` is a name for a commit; **save first, then undo**.

**Done when:** `git log --oneline origin/main..main` prints nothing and `git log --oneline origin/main..feature/export` prints the two commits.

#### 3. lost-work: two accidents, get everything back (10 min)

```bash
cd ../.. && bash git-exercises/lost-work.sh practice-lost-work && cd practice-lost-work
```

Someone ran `git reset --hard HEAD~3` on `main`, and the branch `feature/report` was deleted with `git branch -D`. **Goal:** `main` has all six commits again and `feature/report` exists with its two commits.

Hints: `git reflog`, read from the top; `git branch <name> <commit>`; the deleted branch last pointed at the commit you were on **just before** `checkout: moving from feature/report to main`.

**Done when:** `git log --oneline` shows 6 commits and `git branch` lists `feature/report`. Afterwards: what if the commits had never been committed? Would your colleague's reflog help you?

#### 4. messy-history: clean up before the merge request (8 min)

```bash
cd .. && bash git-exercises/messy-history.sh practice-messy && cd practice-messy
git branch before-cleanup                       # your proof for the end
git -c core.editor=nano rebase -i main          # or vim, or "code --wait"
```

`feature/login` has seven commits (`wip`, `fix`, `oops forgot the form`, `typo`...). **Goal:** three commits with good messages (login logic, the form, the README text) **without changing the final content**. Reorder the todo list so the `login.py` commits are together; make the first one `reword` and fold the others with `fixup`.

> [!NOTE]
> The scenario sets `core.editor` to `true` so nothing opens by accident. Without `-c core.editor=...`, `git rebase -i` accepts the todo list unchanged and appears to do nothing.

**Done when:** `git log --oneline main..` shows three commits and `git diff before-cleanup HEAD` prints nothing. If it goes wrong: `git rebase --abort`.

#### 5. bisect: who broke it (8 min)

```bash
cd .. && bash git-exercises/bisect.sh practice-bisect && cd practice-bisect
./test.sh; echo "exit code: $?"                   # 1 = failing now
git bisect start && git bisect bad
git bisect good "$(git rev-list --max-parents=0 HEAD)"
git bisect run ./test.sh
git bisect reset                                  # always
```

Read the first bad commit (`git show --stat`): the message says one thing, the commit did **two** unrelated things. Undo it with `git revert <commit>`. The revert stops with a **conflict in `CHANGELOG.md`**; keep the current changelog and undo only `calc.sh`:

```bash
git checkout --ours CHANGELOG.md     # during a revert, "ours" is the branch you are on
git add CHANGELOG.md && git revert --continue
```

**Done when:** `./test.sh` passes on `main` and the history still shows both the bad commit and your revert.

#### Check yourself

- [ ] You can resolve a conflict **and** leave one with `--abort`
- [ ] You found a "lost" commit and a deleted branch with the reflog
- [ ] You turned seven commits into three without changing the content
- [ ] You can say when you use `revert` and when `reset`

#### Questions to discuss

- Your team keeps getting conflicts in the same file. Is the problem Git, the branches, or the way work is split?
- Which commands would you never run on `main` of a shared repository? (`reset --hard` or `push --force` after a `rebase`)
- A secret was pushed to `main` an hour ago. `revert` removes it from the latest version. Is it safe now? (No: Chapter 8.)

#### Stretch

- `git stash push -u`, switch branch, `git stash pop`: when is this better than a work-in-progress commit?
- `git config --global rerere.enabled true`, repeat the conflict twice, and see Git remember your resolution

---

## Chapter 3: GitLab for users

Where Git ends and GitLab begins: the interface, groups and projects, roles, and planning work.

### What GitLab adds to Git

[Docs](https://docs.gitlab.com/19.5/user/project/)

```text
                  ┌─────────────────────── GitLab project ───────────────────────┐
 Git repository   │  issues   merge requests   CI/CD pipelines   container/package│
 (history, code)  │  boards   code review      environments      registry         │
                  │  wiki     approvals        security scans    releases         │
                  └───────────────────────────────────────────────────────────────┘
                              one place, one permission model, one audit trail
```

- Git gives you **history and branches**. GitLab gives you the **workflow around them**
- Everything is connected by references: `#12` (issue), `!34` (merge request), `@alice`, commit ids
- **Free** to start; more control and governance in higher tiers

### Tiers: how to read the markers

[Docs](https://docs.gitlab.com/19.5/subscriptions/) · [Tier reference of this course](#appendix-c-tier-reference)

🟢 Free: available in every tier · 🟣 Premium: Premium **and** Ultimate · 🟠 Ultimate: Ultimate only

- **Every GitLab feature in this course carries a marker.** Source: the `Tier:` line of the feature's page on docs.gitlab.com, checked for **GitLab 19.5**
- The same feature can have **parts in different tiers**: SAST scanning is Free, but showing findings in the merge request is Ultimate
- Tiers apply on **GitLab.com**, **Self-Managed** and **Dedicated**. A self-managed server without a licence behaves as Free. A 30-day Ultimate trial unlocks everything
- **Do not assume your company has Premium or Ultimate.** Ask first, and re-read the `Tier:` line before you plan around a feature: tiers change between releases

### The interface

[Docs: the left sidebar](https://docs.gitlab.com/19.5/tutorials/left_sidebar/) · [Keyboard shortcuts](https://docs.gitlab.com/19.5/user/shortcuts/)

Left sidebar of a **project** (a Developer sees fewer entries than a Maintainer):

| Menu | What is inside |
| --- | --- |
| **Manage** | Activity, Members, Labels |
| **Plan** | Work items, Issue boards, Milestones, Wiki |
| **Code** | Merge requests, Repository, Branches, Commits, Tags, Snippets |
| **Build** | Pipelines, Jobs, Pipeline editor, Schedules, Artifacts |
| **Secure** | Audit events, Security configuration (more with Ultimate) |
| **Deploy** | Releases, Package registry, Container registry |
| **Operate** | Environments |
| **Settings** | General, Access tokens, Repository, Merge requests, CI/CD ... (Maintainers and above) |

- **Issues are "work items"** in 19.5: issues, tasks (and epics, 🟣 Premium) share one list
- **Your work** (top left): your projects, groups, merge requests, **To-Do list**, activity
- `?` shows all keyboard shortcuts; `.` opens the **Web IDE** on the current file or branch

### Namespaces

[Docs](https://docs.gitlab.com/19.5/user/namespace/) · [Groups](https://docs.gitlab.com/19.5/user/group/)

A **namespace** is anything that owns projects. Everything before the last slash in a URL is a namespace.

```text
 instance
 ├── user namespace      trainee1/first-project       personal, one owner
 └── group               acme-trainee1                 members, roles, settings
     ├── subgroup        acme-trainee1/platform
     └── subgroup        acme-trainee1/apps
         └── project     acme-trainee1/apps/hello-api
```

- Groups can nest; projects live at any level
- Each level can hold **members**, **variables**, **runners**, **tokens** and **settings** that flow **downwards**
- A project can be moved to another namespace (the URL changes, redirects stay)

### Modelling a team

**A group is an access boundary.** Ask "who should see this together?", not "what is it called?".

| Pattern | Example | Good when |
| --- | --- | --- |
| By team | `acme/platform`, `acme/payments` | Teams own their code |
| By product | `acme/shop/{api,web,mobile}` | Products cross teams |
| By function | `acme/infra`, `acme/shared-ci` | Shared tooling has its own access |
| **By supplier or external** | `acme/vendors/integrations` | Outside people get only this |

Keep it shallow (2 to 3 levels). Shared CI templates and components get **their own group** that everyone can read. Do not put one project per group, and do not put everything in one flat group.

### Visibility

[Docs](https://docs.gitlab.com/19.5/user/public_access/)

| Level | Who can see it |
| --- | --- |
| **Private** | Members only |
| **Internal** | Any signed-in user of the instance |
| **Public** | Anyone, including anonymous |

- A project or subgroup **cannot be more visible than its parent** (*"internal is not allowed since the parent group has a private visibility"*)
- "Internal" means everyone who can **register**. With open sign-up that is the whole internet
- **External users** see only what they are explicitly added to, even for "internal" projects
- The visibility of a **project** and of its **features** (issues, wiki, registry) are set separately

### Roles

[Docs](https://docs.gitlab.com/19.5/user/permissions/) · [Custom roles](https://docs.gitlab.com/19.5/user/custom_roles/)

| Role | Intended for |
| --- | --- |
| **Guest** | Stakeholders, contractors: issues and comments. No code in private projects |
| **Planner** | Product and project managers: planning work items, boards, epics |
| **Reporter** | Read code, reports and artifacts; create and triage issues |
| **Developer** | Write code: branches, merge requests, run pipelines |
| **Maintainer** | Run the project: branch rules, CI/CD settings and **variables**, members |
| **Owner** | Run the group: settings, members at every level, delete |

🟣 Premium **Minimal access**: see the group, nothing inside. 🟠 Ultimate **Custom roles**: pick the exact permissions. A *Security Manager* role exists in 19.5 as a **beta**, disabled by default.

Same project (`hello-api`, private), real accounts, GitLab 19.5, **measured**:

| Role (how granted) | Open project | See files | Commit to `main` | Read CI/CD variables |
| --- | --- | --- | --- | --- |
| Guest (direct) | yes | **no** | no | no |
| Reporter (group) | yes | yes | no | no |
| Developer (group) | yes | yes | **no** | no |
| Maintainer (subgroup) | yes | yes | yes | **yes** |

Two surprises worth remembering: a Developer **cannot** commit to `main` in a fresh project (the default is "fully protected"), and CI/CD variables are managed by **Maintainers and above**. That is what protects production secrets.

### Inheritance and sharing

[Docs](https://docs.gitlab.com/19.5/user/project/members/) · [Sharing](https://docs.gitlab.com/19.5/user/project/members/sharing_projects_groups/)

```text
 acme (Reporter: carol)
 └── apps (Maintainer: bob)
     └── hello-api  ◀── bob is Maintainer here, "Inherited"
```

- Roles flow **down**: a member of a group is a member of everything below. Below, a role can only be **raised, never lowered**
- To reduce access, change it where it was granted, or restructure
- **Sharing a group** with another group (or a project with a group) gives that group a role, capped at the one you pick: the effective role is the **lower** of the member's role and the share role
- Only **direct** members count for some features (approvals, Code Owners): Chapter 4

> [!NOTE]
> **For owners and admins.** The structure you choose here *is* your access-control model, and it is what an auditor samples in an access review. Grant roles on **groups, not on single projects**, keep the number of Owners small, and put suppliers in their own subgroup. Joiner, mover and leaver processes (SSO, SCIM, offboarding) are in Chapter 9.

### Planning work: work items

[Docs](https://docs.gitlab.com/19.5/user/work_items/) · [Labels](https://docs.gitlab.com/19.5/user/project/labels/) · [Boards](https://docs.gitlab.com/19.5/user/project/issue_board/)

- *Plan > Work items* holds **issues**, **tasks** and (with a licence) epics. Fields that matter: **assignee**, **labels**, **milestone**, **due date**, **estimate**
- **Labels** are the lightweight workflow: `type::bug`, `needs-review`, `blocked`. 🟣 Premium **scoped labels** allow only one `status::*` at a time
- **Boards** show issues as cards in label columns: drag a card, the label changes (basic boards 🟢 Free; assignee, milestone and iteration lists, swimlanes 🟣 Premium)
- **Templates** (`.gitlab/issue_templates/`) give every report the same questions (project templates 🟢 Free; group-level templates 🟣 Premium)
- Link work to code: **`Closes #12`** in a commit or merge request closes the issue when it merges. 🟣 Premium epics and iterations group work across projects

### Quick actions

[Docs](https://docs.gitlab.com/19.5/user/project/quick_actions/)

Type them in a description or comment; they run when you save. Type `/` in the editor to see what is available.

```text
/assign @alice          /label ~bug ~"needs review"   /milestone %"v0.2"
/estimate 2h            /spend 45m                    /due next friday
/reviewer @bob          /draft   /ready                /close   /reopen
/relate #7              /merge                         /submit_review
```

Put them in **templates** so every new item arrives pre-labelled and pre-assigned. `/spend` and `/estimate` feed **time tracking** 🟢 Free.

### Staying informed

[To-do list](https://docs.gitlab.com/19.5/user/todos/) · [Notifications](https://docs.gitlab.com/19.5/user/profile/notifications/)

- **To-Do list**: an item appears when you are assigned, mentioned, or asked to review
- **Notifications**: set a **global level** (profile), then override per group or project. "Participate" is a sensible default
- `@alice` notifies one person; `@group` notifies all members, so use with care. **Subscribe** to a single item without being assigned

Mail overload is the usual reason people stop reading GitLab. Tune it once, early.

### Hands-on: model "Acme" and prove who can do what

About 40 minutes. Steps 1 to 5 are the core, 6 is planning, 7 and 8 are for fast groups. 🟢 Free steps work everywhere; 🟣 and 🟠 steps need a Premium or Ultimate trial on the instance, otherwise the trainer shows them on screen.

You lead a fictional team: build its group structure, give four colleagues different roles, and **check the permission matrix by acting as each of them** instead of trusting the documentation. Four persona accounts exist on the instance (the trainer hands out the passwords). Use **four private/incognito browser windows** to stay signed in as each persona:

| Account | Persona | Role you give |
| ------- | ------- | ------------- |
| `alice` | Developer | Developer on the group |
| `bob`   | Team lead | Maintainer on one subgroup |
| `carol` | Auditor | Reporter on the group |
| `dave`  | External contractor | Guest on one project only |

#### 1. Interface scavenger hunt (5 min) 🟢 Free

Open `training/hello-app`. Where are **Merge requests**, **Pipelines** and the **Container registry**? Press `?`: which shortcut opens the Web IDE? Your sidebar has no **Settings**: why? (You are not a Maintainer there.)

#### 2. The structure (4 min) 🟢 Free

Replace `N` with your trainee number (top-level group paths are unique on the instance).

1. **Your work > Groups > New group**: name `Acme N`, slug `acme-traineeN`, **Private**
2. In it, create the subgroups `platform` and `apps` (Private), and in `apps` a blank project `hello-api` (Private, with a README)

#### 3. Give people roles (4 min) 🟢 Free

**Manage > Members > Invite members** on the right level:

| Where | Who | Role |
| ----- | --- | ---- |
| group `acme-traineeN` | alice | Developer |
| group `acme-traineeN` | carol | Reporter |
| subgroup `apps` | bob | Maintainer |
| project `hello-api` (directly) | dave | Guest |

Open `hello-api > Manage > Members` and read the **Source** column: who is "Direct member" and who is "Inherited"?

#### 4. Prove the matrix (8 min) 🟢 Free

In each persona's window open `hello-api`, try to edit `README.md` and commit, and look at the sidebar. Fill in the table:

| Check | alice | bob | carol | dave |
| ----- | ----- | --- | ----- | ---- |
| Can open the project / see the files | | | | |
| Can edit `README.md` and commit to `main` | | | | |
| Can create a new branch | | | | |
| Sees **Settings > CI/CD > Variables** | | | | |
| Can invite another member | | | | |

Who can see CI/CD variables, and why does that matter for a pipeline that deploys to production? What exactly can Dave, a Guest, do in a **private** project?

#### 5. Look at the default, then loosen it on purpose (3 min) 🟢 Free

Only **bob** could commit to `main`, although Alice is a Developer. That is the default, not a mistake. In `hello-api > Settings > Repository > Branch rules`, `main`: set *Allowed to merge* to **Developers + Maintainers** and *Allowed to push* to **No one**. Now everything goes through a merge request. As **alice**, edit `README.md`: what does the editor offer instead of committing? Create the merge request and merge it.

#### 6. Plan a task (10 min) 🟢 Free (scoped labels 🟣 Premium)

1. **Plan > Work items > New item**: `Add /version endpoint`, with a task list (`- [ ] add the endpoint`, `- [ ] add a test`)
2. Add the label `type::feature` and the milestone `v0.2` (create it first). With a trial, make a label **scoped** (`status::todo`, then `status::doing`) and watch the first one disappear
3. Assign it to yourself. In a comment type `/estimate 2h`, then `/spend 30m`
4. **Plan > Issue boards**: add a list for your label and drag the issue. Mention `@dave` and check, in his window, that it lands in his **To-Do list**

#### 7. Inheritance and a machine credential (optional)

1. `hello-api > Manage > Members`: bob is Maintainer, *Inherited* from `apps`. Try to invite him **directly** as Developer: GitLab refuses (a role can only be raised below, never lowered). Invite **dave** directly as Reporter: that works
2. `Settings > Access tokens > Add new token`: name `ci-reader`, role **Reporter**, scope `read_repository`, expiry tomorrow. A new member appeared in **Manage > Members**: who? Why is this better than putting your own personal access token into a pipeline? ([Project access tokens](https://docs.gitlab.com/19.5/user/project/settings/project_access_tokens/): the page states no tier, only the offering: check your own tier before relying on them)

#### Check yourself

- [ ] You can explain why alice can push to a feature branch but not to `main`, before and after you changed the rule
- [ ] You know which of the four can read your CI variables (Maintainers and above)
- [ ] You saw that a Guest cannot read code in a private project
- [ ] You can name two places a member's role can come from (group inheritance, direct) and the rule between them

#### Questions to discuss

- A supplier needs to deploy to production but should not read other teams' code. Which group layout and which role?
- When a contractor leaves, how many places do you have to remove them from? (Designing roles high up is the point.)
- Where would you put CI/CD variables shared by everything in `apps`? (Group *Settings > CI/CD*.)

---

## Chapter 4: Team collaboration

Merge requests, review, protection, code owners, and what an auditor wants to see.

Opening question for the room: *who can change production code in your company without a second person looking?* The honest answer is usually "more people than we think". This chapter shows how GitLab makes the answer "nobody", and how the same settings become audit evidence (SOC 2 Type II is the example).

### The flow we walk

[Docs](https://docs.gitlab.com/19.5/user/project/merge_requests/)

```text
 issue ──▶ branch ──▶ commits ──▶ merge request ──▶ review ──▶ merge ──▶ (pipeline) ──▶ deploy
 #1        1-add-…    + tests     draft → ready     comments   squash    CI/CD          Chapter 6+
                                  reviewer          suggestions
                                                    approvals
```

Each arrow is a place where GitLab can **record**, **check** or **enforce** something. This chapter is mostly about *enforce* and *record*.

### Branching strategies and a team agreement

| Strategy | Idea | Fits |
| --- | --- | --- |
| **Trunk-based** | Short branches, merge to `main` many times a day | Strong CI, feature flags |
| **GitLab flow** | `main` always deployable; feature branches via MRs; optional environment or release branches | Most teams |
| **Release branches** | Maintain several versions in parallel | Products with supported versions |
| Gitflow (develop/release/hotfix) | Many long-lived branches | Rarely needed today |

Pick one and write it down. What matters more than the name: `main` is protected and deployable, branches are short-lived and named after the work (`123-add-version-endpoint`), and everything reaches `main` through a merge request.

Decide the rest once, write it in `CONTRIBUTING.md`, review it twice a year:

| Topic | Example agreement |
| --- | --- |
| Branches | `<issue>-<short-name>`, deleted after merge |
| Commits | Conventional Commits; one purpose each |
| Merge request size | Aim for under 400 changed lines; split otherwise |
| Review time | First response within one working day |
| Who reviews | At least one person who is not the author; owners for sensitive paths |
| Merge method | Squash, fast-forward, or merge commit: one choice per project |
| Definition of done | Tests, docs, pipeline green, threads resolved |
| Emergencies | A defined fast path that still goes through a merge request |

These are **recommendations**, not GitLab features. GitLab can enforce some of them; the rest is team culture.

### Merge methods and squash 🟢 Free

[Docs](https://docs.gitlab.com/19.5/user/project/merge_requests/methods/) · [Squash](https://docs.gitlab.com/19.5/user/project/merge_requests/squash_and_merge/)

*Settings > Merge requests*

| Merge method | History looks like | Use when |
| --- | --- | --- |
| **Merge commit** (default) | Branches visible, merge commits | You want the true history |
| **Merge commit with semi-linear** | Rebase required first, then a merge commit | Linear-ish history, keep MR grouping |
| **Fast-forward** | Perfectly linear, no merge commits | `git bisect`, simple changelogs |

**Squash** (*Do not allow / Allow / Encourage / Require*) collapses the branch into one commit. Merge checks: **pipeline must succeed** and **all threads resolved**; the source branch is removed after merge by default. 🟣 Premium *Merged results pipelines* and *merge trains* test the result of the merge before it happens.

### A good merge request, and a good review

[Docs](https://docs.gitlab.com/19.5/user/project/merge_requests/reviews/) · [Suggestions](https://docs.gitlab.com/19.5/user/project/merge_requests/reviews/suggestions/)

**Author**

1. **Small.** Reviewers find fewer problems in 1,000 lines than in 100
2. **Described**: what and why, how to test, the linked issue (a description **template** does this)
3. **Draft** until you want a review (`Draft:` blocks the merge button)
4. **Green pipeline** before asking people to look
5. **Reviewers** check it; **assignees** own it

**Reviewer**: read the description first, then the tests, then the code. Ask questions before giving orders. Use **suggestions** (one click to apply) 🟢 Free for small fixes. Separate "must fix" from "nit", and resolve threads. 🟣 Premium *Prevent merge when you request changes*.

### Protection is not review

A **Developer can merge her own change** when the rule is "Developers + Maintainers may merge". Each mechanism answers a different question:

| Mechanism | Answers the question | Tier |
| --- | --- | --- |
| [Protected branch](https://docs.gitlab.com/19.5/user/project/repository/branches/protected/) | **Who** may push or merge? | 🟢 Free |
| Pipeline must succeed / threads resolved | Is it **green and discussed**? | 🟢 Free |
| Required approvals | **Did anybody else look?** How many? | 🟣 Premium |
| Prevent author approval; prevent approval by committers | Can I approve my own change? (no) | 🟣 Premium |
| Code owners | Did the **right** people look at this file? | 🟣 Premium |
| [Push rules](https://docs.gitlab.com/19.5/user/project/repository/push_rules/) | Is the **commit itself** acceptable? | 🟣 Premium |

A good baseline for `main`: *no direct push* + *1 approval, not the author* + *code owners for pipeline and deploy files* + *pipeline must succeed*.

### Approvals 🟣 Premium

[Docs](https://docs.gitlab.com/19.5/user/project/merge_requests/approvals/) · [Settings](https://docs.gitlab.com/19.5/user/project/merge_requests/approvals/settings/) · [Rules](https://docs.gitlab.com/19.5/user/project/merge_requests/approvals/rules/)

*Settings > Merge requests > Merge request approvals*. **Rules** define how many approvals, from whom, for which branch. **Eligible approvers** are **direct members** with at least the Developer role (inherited members are not considered). Settings worth turning on:

| Setting | Effect |
| --- | --- |
| Prevent approval by merge request creator | The author cannot approve (default on) |
| Prevent approvals by users who add commits | Anyone who pushed a commit to the MR cannot approve; a rebase counts |
| Prevent editing approval rules in merge requests | Authors cannot lower the bar for their own MR |
| Remove all approvals when commits are added | New changes need new approval (default on) |
| Remove approvals by Code Owners if their files changed | Only affected owners must approve again |

Optional approvals (no requirement, just a signal) exist in 🟢 Free.

> [!NOTE]
> **For owners and admins.** These settings live in each project, so a Maintainer can weaken them there. On 🟣 Premium they can be set once for an instance or a top-level group, where they are **locked** for the projects below (Chapter 9). For rules that must hold across many projects and survive a Maintainer's good intentions, use security policies (🟠 Ultimate).

### CODEOWNERS: what and why 🟣 Premium

[Docs](https://docs.gitlab.com/19.5/user/project/codeowners/) · [Syntax reference](https://docs.gitlab.com/19.5/user/project/codeowners/reference/)

A file in the repository says **who is responsible for which paths**. Owners are shown on the file and directory in the UI. With a **protected branch** and *Require approval from code owners*, a merge request that touches an owned path cannot merge without an owner. It is **code**: versioned, reviewed, and part of the audit trail.

| Problem | What CODEOWNERS does |
| --- | --- |
| "Anyone can change the deploy pipeline" | Only the platform group approves `.gitlab-ci.yml` and `deploy/` |
| Review requests go to whoever is online | The people who know the area are asked |
| New joiners do not know who to ask | Owners are visible in the UI |
| "Who approved this change in production code?" | The merge request shows the approval, tied to a named person |
| Changes to the rules themselves | The `CODEOWNERS` file changes through a reviewed merge request |

**The pipeline file is the most security-sensitive file in the repository.** Give it an owner.

### CODEOWNERS: the syntax

A sample file is in [`examples/codeowners/CODEOWNERS`](examples/codeowners/CODEOWNERS).

```text
# Everything needs the team (the "default" entry)
* @acme/developers

# Directory with everything below it
/deploy/ @acme/platform

# A section groups rules; owners after the name are defaults; [..][2] needs two approvals
[Pipeline and deployment][2] @acme/platform
.gitlab-ci.yml
/ci/

# Optional section: suggested, not required
^[Documentation] @acme/developers
/docs/

# A role can be an owner (Developer, Maintainer, Owner)
/config/ @@maintainers

# Exclude a path from needing code owner approval
!/docs/generated/
```

- File location: `./CODEOWNERS`, `./docs/CODEOWNERS` or `./.gitlab/CODEOWNERS`. The **first one found** is used
- Inside a section the **last matching entry** wins; across sections **each** section needs its approval. Section names are case-insensitive; same-named sections are combined
- Owners: `@user`, `@group`, e-mail, roles `@@maintainers`. `[Section][2]` needs two approvals (the minimum is 1)
- **Inline comments are not supported**, and owners written in one are still parsed: comments go on their own line
- Patterns without a leading `/` can match **in any directory**: check for accidental matches

### CODEOWNERS: enforcing it

1. Owners must be **direct members** with Developer or higher. Groups work when they are direct members of the project, its group or a parent group
2. *Settings > Repository > Branch rules* on `main`: **Allowed to push and merge: No one**, **Require approval from code owners** on
3. Commit the file **through a merge request**. The rules are read from the **target branch**, so this first merge request is not gated by the file, and no merge request can weaken the rules it is merged under
4. Test it: an owned file, an owner-less file, a direct push (Hands-on, step 7)

Without step 2 it is only a label. Users *allowed to push* can **skip the whole merge request**: do not rely on the sentence in the documentation that says a direct push is denied when a rule matches; set push to **No one** and test it on your instance.

> [!TIP]
> 🟢 **Free fallback:** keep the file as documentation, protect `main` with *push: No one*, and agree on reviewers by hand. GitLab will not enforce who approves.

### CODEOWNERS: pitfalls

| Pitfall | What happens | Fix |
| --- | --- | --- |
| **No entry matches** a file | No code owner approval needed, including new and renamed files | Add `* @team` at the top |
| **Inline comment** after an owner | Owners in the comment are parsed too | Comments on their own line |
| Misspelled owner, leaver, not a direct member | Owner is silently ignored | Review the file after reorganisations; prefer **groups** |
| Entry with **no resolvable owner** | Can never be satisfied; the docs describe it as auto-approved in MRs | Check the file view after changes |
| `CODEOWNERS` has no owner itself | Anyone with merge rights can change who approves | List `/.gitlab/CODEOWNERS` in itself (a recommendation, not a feature) |
| Owner **commits** to the MR | Cannot approve their own owned files | Another owner approves |
| Renamed user or group | The file is not updated | Edit the file |
| Two sections match a file | Approval is needed from the last matching entry **of each** section | Read the *Approvals* box of the MR |

### Push rules and signed commits

[Push rules](https://docs.gitlab.com/19.5/user/project/repository/push_rules/) · [Signed commits](https://docs.gitlab.com/19.5/user/project/repository/signed_commits/)

🟣 Premium *Settings > Repository > Push rules* are checked on every push, before anything is stored: commit message must match a regex (for example Conventional Commits), branch name pattern, prevent pushing **secret files** (private keys, `.env`), reject unsigned commits, limit file size and names, committer e-mail must belong to your domain.

🟢 Free **Signed commits**: GitLab *verifies* GPG, SSH and X.509 signatures and shows a badge. 🟣 Premium **Enforcing** signatures requires a push rule. Cheap, immediate feedback, and a safety net for the "oops, I committed the key" case.

### From settings to evidence: audits

[Audit events](https://docs.gitlab.com/19.5/user/compliance/audit_events/) · [Streaming](https://docs.gitlab.com/19.5/user/compliance/audit_event_streaming/)

An auditor asks: **"Show me that changes to production code were reviewed and approved by someone authorised, and that nobody can bypass it."** GitLab is the evidence source for each part:

| Question | Evidence | In GitLab | Tier |
| --- | --- | --- | --- |
| Who may approve what? | `CODEOWNERS`, versioned | Repository | 🟣 Premium |
| Is the gate on, and can it be bypassed? | Branch rule: push = No one, code owner approval on | Settings > Repository > Branch rules | 🟢 Free / 🟣 Premium |
| Was it followed for this change? | The **merge request**: approvals, pipeline | Merge request | 🟢 Free view, 🟣 Premium required |
| Did the rules change in the period? | **Audit events** | Secure > Audit events | 🟣 Premium |
| Keep events outside GitLab | Streaming to a SIEM | Audit event streaming | 🟠 Ultimate |

- Audit events are **retained indefinitely** (19.5 docs). Filter by user and date range. Viewing needs Maintainer or higher in a project, Owner for a group
- **"A merge request is approved" is not stored** in the audit events list (it is available through streaming only). The **merge request** is the evidence for approvals; audit events prove the rules were configured as claimed and did not change
- Evidence must cover the **whole period**. A screenshot of today proves little; an audit events list showing "no change since the start of the period" proves more

### SOC 2 Type II in plain words

[Docs: compliance features](https://docs.gitlab.com/19.5/user/compliance/)

> [!IMPORTANT]
> This is an engineering view, **not audit, legal or certification advice**. The criteria are **paraphrased from general knowledge** of the AICPA Trust Services Criteria (the AICPA text was not available while writing), and reference numbers such as CC8.1 are pointers, not quotations. **Your auditor and your compliance owner decide what satisfies a control.** GitLab produces evidence; it does not make anyone "SOC 2 compliant".

- A **report** from an independent auditor about a company's **controls**, organised by the Trust Services Criteria. Not a certificate, no pass or fail
- **Type I**: controls are suitably designed at one date. **Type II**: designed **and operating effectively over a period** (commonly 3 to 12 months)
- The company writes the controls; the auditor **samples** events from the whole period and tests them. **One failure in the sample is an exception**, even if the rest was perfect

Consequences for developers: follow the process **every time**, including emergencies and including managers. Evidence is created **by the normal workflow** and cannot be reconstructed afterwards. Settings can change, and audit events show whether they did.

| Control idea (paraphrased) | Reference | You do | GitLab (tier) |
| --- | --- | --- | --- |
| Changes are authorised, tested and approved before release | CC8.1 | Merge requests only; no direct push | Protected branch, pipelines 🟢 Free; required approvals 🟣 Premium |
| The right people review the right changes | CC8.1, CC6.x | Know the owners | CODEOWNERS 🟣 Premium |
| The author cannot approve their own work | CC8.1 | Never approve your own change | Approval settings 🟣 Premium |
| Only authorised people release | CC6.x, CC8.1 | Release through the pipeline | Protected tags 🟢 Free; protected environments, deployment approvals 🟣 Premium |
| Access is by role and reviewed | CC6.1-6.3 | Request access properly | Roles 🟢 Free; custom roles 🟠 Ultimate |
| Vulnerabilities are found and handled | CC7.1 | Triage findings | Scanners in CI 🟢 Free; vulnerability management 🟠 Ultimate |
| Secrets are handled properly | CC6.1, CC6.7 | Never commit secrets; masked, protected variables; rotate | Masked and protected variables 🟢 Free; environment scope, external secrets 🟣; secret push protection 🟠 |
| Commits are traceable | CC8.1 | Sign commits where the policy says so | Verification 🟢 Free; enforcing via push rules 🟣 Premium |
| Activity is logged | CC7.2 | Do not delete evidence | Audit events 🟣 Premium |

#### Emergencies belong inside the process

The sampled change that was "just a hotfix at 2 am" is the classic exception.

1. **Define** an expedited path in the working agreement: same merge request, one approval from an on-call owner, pipeline still runs
2. **Use** it, and write the reason in the merge request
3. **Review afterwards**: a follow-up item closed by a named person
4. Keep **break-glass** access (an administrator who can bypass) rare, logged and reviewed

Auditors dislike a bypass nobody can explain; they accept a documented exception that was followed.

#### Developer checklist

- [ ] Every change reaches `main` through a merge request. I never push to `main`
- [ ] I do not approve my own change, and I do not approve what I do not understand
- [ ] A pipeline passes before merge, and I read why it failed before retrying
- [ ] When I change who owns a path, I change `CODEOWNERS` through a merge request too
- [ ] I put the **reason** and the ticket in the merge request, so a sampled change explains itself
- [ ] Secrets never go in the repository. If one does, I rotate it first and tell the security owner
- [ ] I ask the compliance owner before changing branch protection, approval rules or pipeline security jobs

### Hands-on: from issue to reviewed merge, and prove the gate

About 45 minutes. Steps 1 to 4 are 🟢 Free and the core (about 20 min). Steps 5 to 8 need 🟣 Premium (a trial on the instance); steps 7 and 8 prove that the controls work. Without a trial the trainer shows steps 5 to 8 on screen. You work on the sample application as yourself, and review as `alice` / `bob` in the browser windows from Chapter 3 (`alice` is a Developer in your group, `bob` a Maintainer in `apps`).

#### 1. Fork the sample application (3 min) 🟢 Free

1. Open **`training/hello-app`** (a small Python service, a `Dockerfile`, tests, a `ci-steps/` folder; **no pipeline yet**, on purpose) and **Fork** it into **`acme-traineeN / apps`**, Private
2. In your fork: **Settings > Repository > Branch rules**, `main`: *Allowed to push* **No one**, *Allowed to merge* **Developers + Maintainers**

> [!WARNING]
> When you create a merge request from a fork, the *target* may default to the upstream project. In this lab the target is always **your fork's `main`**.

#### 2. Plan, branch, commit, merge request (10 min) 🟢 Free

1. **Plan > Work items > New item**: `Add /version endpoint`, label `type::feature`, milestone `v0.2`, assign to yourself, and `/estimate 2h` in a comment
2. On the issue use **Create merge request** to create the MR **and branch**. Clone your fork and switch to the branch:

   ```bash
   git clone git@<gitlab-host>:acme-traineeN/apps/hello-app.git && cd hello-app
   git fetch && git switch 1-add-version-endpoint
   ```

3. Append to `app/main.py` and `tests/test_app.py`, commit with a Conventional Commit message and `Closes #1`, and push:

   ```python
   @app.get("/version")
   def version():
       return jsonify(version=VERSION)
   ```

   ```python
   def test_version():
       response = app.test_client().get("/version")
       assert response.status_code == 200
       assert "version" in response.get_json()
   ```

   ```bash
   git commit -am "feat(app): add /version endpoint" -m "Closes #1"
   git push
   ```

#### 3. Review, and the dangerous part (7 min) 🟢 Free

1. Fill in the MR description (the project has a **template**; mark a Draft ready). Set **alice** as **Reviewer**, not Assignee
2. In alice's window: **Changes**, comment on a line, propose a **suggestion**, submit the review. As yourself: apply the suggestion, resolve the thread
3. Before anyone approves, can *you* merge your own MR? Look at the **Merge** button. It works, because "Developers + Maintainers may merge" says nothing about review

> [!IMPORTANT]
> Branch protection decides **who may merge**. It does not decide **whether anybody looked at it**.

#### 4. Make review mandatory (5 min) 🟣 Premium

1. **Settings > Merge requests > Merge request approvals**: rule `Maintainer review`, **1 approval**, approver **bob**. Enable *Prevent approvals by users who add commits* and *Prevent editing approval rules in merge requests*; check that *Prevent approval by merge request creator* and *Remove all approvals when commits are added* are on
2. Reload the MR: **Merge** is blocked. Try **Approve** as yourself. Bob approves in his window. Merge (choose **Encourage squash**): the issue is closed, the branch deleted, `main` has one tidy commit

#### 5. Code owners (6 min) 🟣 Premium

1. New issue, branch and MR `Add CODEOWNERS`. Create **`.gitlab/CODEOWNERS`** (comments on their own lines on purpose):

   ```text
   # Default: everything is reviewed by alice
   * @alice

   [Delivery] @bob
   .gitlab-ci.yml
   Dockerfile
   /deploy/

   [Ownership] @bob
   /.gitlab/CODEOWNERS
   ```

2. Bob approves, you merge. Then switch the gate on: **Branch rules > `main` > Require approval from code owners**
3. Open a file in **Code > Repository**: are the owners shown? Why did this MR **not** need alice or bob as *code owners*? (The file is read from the **target branch**, where it did not exist yet.)

#### 6. Prove the gate (10 min) 🟣 Premium

Write your **prediction** first, then test, each in a new branch and MR:

| # | Test | Prediction | Result |
| - | ---- | ---------- | ------ |
| A | Change a comment line in `Dockerfile`. Who must approve? | | |
| B | Add a new file `NOTES.md`. Who must approve? (the MR's *Approvals* box) | | |
| C | As **bob**, add a commit to **your** MR branch, then try **Approve** as bob | | |
| D | Try **Approve** on your own MR | | |
| E | As **bob**, edit `Dockerfile` and commit **directly to `main`** | | |

Test E needs the rule relaxed on purpose: set *Allowed to push and merge* to **Maintainers**, run it, then **set it back to No one**. The documentation says both that users allowed to push skip merge requests (and code owner approval) and that a direct push is denied if a rule matches. **What does your instance do?** Write the answer down: it is the evidence you would show an auditor.

Discuss: which test showed a gate can be walked around, and what closes that gap? Who may change `CODEOWNERS` itself, and why is that the most important line in the file?

#### 7. Read the audit trail (4 min) 🟣 Premium

As Owner open **Secure > Audit events** in `hello-app`, filter by your user and today's date. List the events that match steps 1 to 6 (branch rule changes, approval rule created, settings changed). Look for **merge request approval** events: are they there? (They are not stored; the evidence is the MR.) Who could see the **group** events, and who only the **project** events?

#### 8. Leave the project workable (3 min)

The next chapters merge more changes, mostly alone. Relax the gate and say aloud what you gave up: switch **Require approval from code owners** off, set `Maintainer review` to **0** approvals, and keep `.gitlab/CODEOWNERS`, *Allowed to push: No one* and *Prevent approval by merge request creator*. (Or leave everything on and ask bob and alice to approve each time.) Without a trial none of the approval settings exist: skip steps 4 to 7 and merge as usual.

#### Check yourself

- [ ] The issue closed itself when the change merged
- [ ] You saw that without an approval rule the author can merge their own change
- [ ] You can explain why the first `CODEOWNERS` merge request was not gated by the file
- [ ] You know which evidence is in the merge request and which in audit events

#### Questions to discuss

- Your supplier's pipeline file changed on a Friday afternoon and nobody noticed for a week. Which settings from this chapter prevent that?
- A rule says "1 approval". The only Maintainer is on holiday. What is the escape hatch, who holds it, and where is its use recorded?
- An auditor samples a merge request from March. What do you show?

---

## Chapter 5: Registries, releases and security scanning

Where build output lives, and what the scanners add.

### What a build produces

```text
 commit ──▶ image        Container Registry     docker pull registry.host/group/project:sha
        ──▶ package      Package Registry       npm, PyPI, Maven, generic ...
        ──▶ release      Releases               tag + notes + links to the above
```

All three live **inside the project**, share its permissions and show up in the same UI. No separate Nexus, Harbor or Artifactory is needed to get started. 🟢 Free

### Container Registry 🟢 Free

[Docs](https://docs.gitlab.com/19.5/user/packages/container_registry/) · [Deploy tokens](https://docs.gitlab.com/19.5/user/project/deploy_tokens/)

- One registry per project: `registry.host/<group>/<project>[/<image>]:<tag>`. Access follows project roles: Reporter+ pulls, Developer+ pushes
- *Deploy > Container registry* shows tags, sizes and digests
- Three credentials you will meet:

| Who | Credential |
| --- | --- |
| A **person** | personal access token (`read_registry` / `write_registry`) |
| A **pipeline** | the job's own `CI_REGISTRY_USER` / `CI_REGISTRY_PASSWORD`, valid while the job runs |
| A **server that only pulls** | a **deploy token** with `read_registry` (the registry grants such a token only `["pull"]`, even when it asks to push) |

### Keeping a registry healthy 🟢 Free

[Docs: cleanup policies](https://docs.gitlab.com/19.5/user/packages/container_registry/reduce_container_registry_storage/) · [Dependency proxy](https://docs.gitlab.com/19.5/user/packages/dependency_proxy/) · [Protected tags](https://docs.gitlab.com/19.5/user/project/protected_tags/)

- Registries only grow: every pipeline can push an image. **Cleanup policies** (keep N tags, remove tags older than X days, match by name regex) are available in every tier. Turn them on **at the start**
- Deleting a tag does not free disk space: layers are freed by **garbage collection** (on self-managed, an administrator task)
- The group **Dependency Proxy** caches images from Docker Hub in your GitLab and avoids Docker Hub rate limits for your runners
- Tag with the **commit SHA**; `latest` and `main` are moving pointers. **Protected tags** restrict who can create `v*` tags, which often start a release deployment

### Package Registry 🟢 Free

[Docs](https://docs.gitlab.com/19.5/user/packages/package_registry/)

Same idea for libraries: publish with the build, consume with your normal package manager.

| Format examples | Authenticate with |
| --- | --- |
| npm, PyPI, Maven, NuGet, Composer, Conan, Helm charts, Terraform modules, Go proxy | Personal or project token, deploy token, **job token** |
| **Generic** (any file, `curl --upload-file`) | Same |

Packages belong to a **project** and can be exposed through a **group** endpoint. Deploy tokens with `write_package_registry` / `read_package_registry` give least-privilege machine access. Clean up old versions. 🟣 Premium *audit events* for package registry actions.

### Releases 🟢 Free

[Docs](https://docs.gitlab.com/19.5/user/project/releases/)

A **release** = a Git tag + notes + links to assets, attached to a version. Create it from the UI, the API, or in a pipeline with the `release:` keyword. It makes "**what is deployed?**" answerable: environment, deployment, commit, release. 🟠 Ultimate release metrics (the rest of releases is Free). **Protect the tags** that trigger releases or deployments.

### The scanners

[Docs](https://docs.gitlab.com/19.5/user/application_security/)

All run **inside your pipeline**, on your runners, and write a JSON report.

| Scanner | Looks at | Finds | Runs in pipelines | Extras |
| --- | --- | --- | --- | --- |
| [**SAST**](https://docs.gitlab.com/19.5/user/application_security/sast/) | Your source code | Injection, weak crypto, unsafe functions | 🟢 Free | 🟠 Advanced SAST |
| [**Secret detection**](https://docs.gitlab.com/19.5/user/application_security/secret_detection/) | Repository content and history | Tokens, keys, passwords | 🟢 Free | 🟠 push protection |
| [**Container scanning**](https://docs.gitlab.com/19.5/user/application_security/container_scanning/) | An image's OS packages and libraries | Known CVEs in the image | 🟢 Free | 🟠 scanning of the registry |
| [**IaC scanning**](https://docs.gitlab.com/19.5/user/application_security/iac_scanning/) | Terraform, Kubernetes, Dockerfile | Insecure configuration | 🟢 Free | |
| [**Dependency scanning**](https://docs.gitlab.com/19.5/user/application_security/dependency_scanning/) | Libraries you depend on | Known CVEs in packages | 🟠 Ultimate | |
| [**DAST**](https://docs.gitlab.com/19.5/user/application_security/dast/) | A **running** application | Runtime weaknesses | 🟠 Ultimate | |

Enabling one is **two lines**:

```yaml
include:
  - template: Jobs/SAST.gitlab-ci.yml
  - template: Jobs/Secret-Detection.gitlab-ci.yml

variables:
  AST_ENABLE_MR_PIPELINES: "true"
```

Read from the real 19.5 templates: the jobs land in the **`test`** stage (a custom stage list needs `test`); they run on **your runner** and pull analyzer images from `registry.gitlab.com`; they are `allow_failure: true`, so **findings do not fail the pipeline**; in **merge request pipelines** they only run when `AST_ENABLE_MR_PIPELINES` is `"true"`; SAST skips `spec, test, tests, tmp` by default.

### What you get, per tier

| What you get | Free / Premium | Ultimate |
| --- | --- | --- |
| Scanner runs, JSON report as a **job artifact** | yes | yes |
| Findings in the **merge request** (widget and changed lines) | - | yes |
| **Security** tab on the pipeline | - | yes |
| **Vulnerability report**: triage, dismiss, create issue | - | yes |
| **Dependency scanning**, dependency list | - | yes |
| **Secret push protection** (blocks the push) | - | yes |
| **Security policies**: force scans, require approval | - | yes |

**On Free you still get the JSON report and a real scanner.** What GitLab *does with the findings* is Ultimate. A job of your own can read the JSON and fail on a critical finding (Chapter 8).

### Scanning is not enforcing

In the hands-on: 3 findings and a **green pipeline**. That is the default. Scanners **inform**; something must **decide**. From light to strong:

- Review findings as part of the merge request (humans)
- A job that fails on severity at or above "high" (code you own) 🟢 Free
- A **merge request approval policy**: block unless security approves 🟠 Ultimate
- A **scan execution policy**: scans run whatever the project's pipeline says 🟠 Ultimate

> [!IMPORTANT]
> You cannot rely on a protection that the people being checked can remove. A project can simply not include the scanners; a policy lives **outside** the repository that is being checked. Chapter 8 returns to this, and Chapter 9 shows where policies are defined and what they can and cannot do.

### When a secret leaks

[Docs](https://docs.gitlab.com/19.5/user/application_security/secret_detection/)

1. **Revoke it**: first, immediately, before anything else
2. Find where it was used (audit events 🟣 Premium, logs)
3. Remove it from the repository **and** from history (`git filter-repo` or GitLab's *Redact text*, see [repository size](https://docs.gitlab.com/19.5/user/project/repository/repository_size/))
4. Rotate everything it protected

Prevent: secret detection in CI (finds it after the push) 🟢 Free, push rules for secret **files** 🟣 Premium, **secret push protection** (blocks the push) 🟠 Ultimate. Better: do not use long-lived secrets (Chapter 8).

> [!NOTE]
> **For owners and admins.** Registry credentials are the supply-chain edge: prefer short-lived job credentials and pull-only deploy tokens with an **expiry**, and inventory the long-lived ones. Chapter 9 covers instance-wide expiry rules (some are 🟠 Ultimate).

### Hands-on: images, packages, a release, and security scanning

About 35 minutes, in your fork `acme-traineeN/apps/hello-app` (Chapter 4). Steps 1 and 2 work in every tier; viewing findings in step 3 needs the Ultimate trial. Docker or Podman on your laptop is needed for step 1; without one, follow it on the trainer's screen.

#### 1. Container Registry (8 min) 🟢 Free

**Deploy > Container registry** shows the exact `docker login`, `build` and `push` commands for your project.

1. Create a token: **Edit profile > Access > Personal access tokens**, scopes `read_registry` and `write_registry`, expiry tomorrow
2. Build, log in, push (use the host names from that page):

   ```bash
   echo "<token>" | docker login <registry-host> -u traineeN --password-stdin
   docker build -t <registry-host>/acme-traineeN/apps/hello-app:manual-1 .
   docker push <registry-host>/acme-traineeN/apps/hello-app:manual-1
   ```

   > **Warning.** If the push ends with `error from registry: blob unknown to registry`, your Docker added attestation manifests that the GitLab 19.5 registry did not accept. We saw it in the lab's CI build with Docker 29, so a recent Docker Desktop may do the same. Build again with `BUILDX_NO_DEFAULT_ATTESTATIONS=1 docker build ...` (PowerShell: `$env:BUILDX_NO_DEFAULT_ATTESTATIONS = "1"` first) and push again.

3. Reload the registry page: look at the **tag**, its size and digest. Then make a credential for a server that only **pulls**: **Settings > Repository > Deploy tokens**, name `puller`, scope **`read_registry`** only
4. Prove it is pull-only:

   ```bash
   docker logout <registry-host>
   echo "<deploy-token>" | docker login <registry-host> -u <deploy-token-username> --password-stdin
   docker pull <registry-host>/acme-traineeN/apps/hello-app:manual-1     # works
   docker tag  <registry-host>/acme-traineeN/apps/hello-app:manual-1 <registry-host>/acme-traineeN/apps/hello-app:manual-2
   docker push <registry-host>/acme-traineeN/apps/hello-app:manual-2     # denied
   ```

5. **Settings > Packages and registries**: set the **cleanup policy** to keep the 5 most recent tags and remove tags older than 7 days. Why does an instance need this?

#### 2. Package Registry and a release (6 min) 🟢 Free

1. Upload a *generic package* with a token of scope `api` (the project ID is on **Settings > General**):

   ```bash
   echo "release notes draft" > notes.txt
   curl --header "PRIVATE-TOKEN: <token>" --upload-file notes.txt \
     "https://<gitlab-host>/api/v4/projects/<project-id>/packages/generic/notes/1.0.0/notes.txt"
   ```

2. Find it under **Deploy > Package registry**. Who may download it? (Everyone who can read the project.)
3. **Code > Tags > New tag** `v0.1.0` from `main`, then **Deploy > Releases > New release** with notes and the package as an asset link. Where would you look to find out *which commit produced the image running in production*? (Tomorrow: every image tag is the commit SHA.)

#### 3. Security scanning (18 min) 🟢 Free to run, 🟠 Ultimate to view in GitLab

1. `git switch main && git pull && git switch -c add-security-scans`
2. Add **deliberately bad code** so there is something to find. `app/insecure.py`:

   ```python
   """Deliberately insecure code for the security lab. Never use any of this."""

   import hashlib
   import subprocess


   def run(command):
       # Command injection: a value from outside reaches a shell.
       return subprocess.run(command, shell=True)


   def digest(password):
       # A broken hash function for passwords.
       return hashlib.md5(password.encode()).hexdigest()
   ```

   and a **leaked secret**, `config.env` (a made-up token in GitLab's format, assembled by the command so that it is not written out in this document):

   ```bash
   cat > config.env <<EOF
   APP_ENV=dev
   # copied from my laptop by accident
   GITLAB_TOKEN=glpat-$(printf 'aB3dE5gH7jK9mN1pQ3sT')
   EOF
   cat config.env        # the file now holds a complete, fake, token-shaped string
   ```

3. Turn scanning on with [`examples/ci/step-security-scans.yml`](examples/ci/step-security-scans.yml) (in the project: `ci-steps/step-security-scans.yml`), commit, push, open a **merge request** and do not merge it:

   ```bash
   cp ci-steps/step-security-scans.yml .gitlab-ci.yml
   git add -A && git commit -m "Enable security scanning" && git push -u origin add-security-scans
   ```

4. In **Build > Pipelines** (the first run downloads scanner images and takes a few minutes) open the jobs `semgrep-sast` and `secret_detection`. Read the log and **download the artifacts** `gl-sast-report.json` and `gl-secret-detection-report.json`. Expected: **2 SAST findings** (OS command injection, high; broken hash, medium) and **1 secret** (a GitLab personal access token, critical)
5. 🟠 Ultimate The merge request **security widget** lists the findings, the pipeline has a **Security** tab, and **Secure > Vulnerability report** keeps them over time. Dismiss one with a reason, create an issue from another
6. **The pipeline is green.** The scanners may fail without failing it (`allow_failure: true`). What would make the MR unmergeable on a *critical* finding? 🟠 A **merge request approval policy** (*Secure > Policies*); in any tier, a job of your own that fails on the report
7. The leaked token: if it were real, what is the first thing to do? (Revoke it. Removing the file does not remove it from history.)

#### Check yourself

- [ ] Your image is in the registry, and a pull-only deploy token cannot push
- [ ] You can name the three findings and the files they are in
- [ ] You can explain why a green pipeline does not mean "no vulnerabilities"

#### Questions to discuss

- A registry runs for a year and the disk fills up. What are the two causes and the two mitigations? (Many tags and large layers; cleanup policies and garbage collection.)
- A scanner finds a vulnerability in a library the supplier pinned. Whose problem is it, and how would you want to hear about it?
- Where would you rather catch a leaked token: in the merge request, by a push rule, or by secret push protection? What does each cost?

#### Stretch

- Remove `AST_ENABLE_MR_PIPELINES` and compare merge request pipelines with branch pipelines
- Add `SECRET_DETECTION_EXCLUDED_PATHS: "config.env"` and watch the finding disappear. Is that a fix?
- 🟠 Add `template: Jobs/Dependency-Scanning.gitlab-ci.yml`: how does it differ from SAST? (SAST looks at your code, this at other people's code you depend on.)

---

## Chapter 6: CI/CD fundamentals

From a commit to a running job. CI/CD itself, runners, artifacts, cache and the pipeline editor are 🟢 Free; Premium adds protected environments, deployment approvals and environment-scoped variables, and the security results in the UI are Ultimate. Every pipeline question comes back to two things: **what runs, and what it can touch.**

### Why a pipeline

[Docs](https://docs.gitlab.com/19.5/ci/)

**Continuous integration**: every change is built and tested automatically, by a machine, the same way. **Continuous delivery/deployment**: the tested result is released by the same machine, the same way.

- The pipeline definition is **a file in the repository** (`.gitlab-ci.yml`): reviewed, versioned, diffable
- A manual deployment is a procedure in someone's head; a pipeline is the procedure written down and **executed**
- The flip side: whoever can change that file can make a machine do things with your credentials

### Vocabulary

```text
 pipeline
 ├── stage: test                 stages run one after another
 │   ├── job: lint               jobs in a stage run in parallel
 │   └── job: unit-tests
 ├── stage: build
 │   └── job: build-image
 └── stage: deploy
     └── job: deploy-dev
```

| Term | Meaning |
| --- | --- |
| **Job** | A script that runs on a runner, in one clean environment |
| **Stage** | A group of jobs; a failed stage normally stops the pipeline |
| **Runner** | The program (on some machine) that executes jobs |
| **Executor** | How the runner runs a job: shell, Docker, Kubernetes, ... |
| **Artifact** | A file or directory a job keeps for later jobs and for people |

### How a job really runs

[Docs](https://docs.gitlab.com/19.5/ci/pipelines/)

```text
 1. push / MR / schedule ──▶ GitLab creates the pipeline (reads .gitlab-ci.yml)
 2. job becomes "pending" in the queue
 3. a runner asks GitLab "any job for me?"     ◀── the RUNNER connects OUT; GitLab never connects in
 4. runner starts a container (executor), clones the repo, runs the script
 5. logs stream back; artifacts and cache are uploaded
 6. job passes or fails; GitLab updates the pipeline, the MR, the environment
```

Runners need only **outbound HTTPS** to GitLab, no inbound firewall hole. "Pending forever" means no runner can take the job (**tags**, scope, paused, offline). A job sees whatever the **runner's network** sees, not what your laptop sees.

### Runners and executors

[Docs: runners](https://docs.gitlab.com/19.5/ci/runners/) · [Executors](https://docs.gitlab.com/runner/executors/)

| Executor | Runs jobs in | Notes |
| --- | --- | --- |
| **Docker** | A fresh container per job | The common choice; our lab. Needs `image:` |
| Kubernetes | A pod per job | Scales with the cluster |
| Shell | The runner machine itself | Fast, **no isolation**: jobs can touch the host |
| Docker Autoscaler / instance | Cloud VMs created on demand | Scale to zero, strong isolation |

Scope: **instance** runners (everyone), **group** runners, **project** runners. **Tags** route jobs: a job with `tags: [docker]` only runs on runners that have that tag. On **GitLab.com** there are hosted runners (with a monthly allowance that depends on your tier); on **self-managed** your team or its administrators provide them. Ask who owns them: a runner sees every secret of every job it runs.

> [!NOTE]
> **For owners and admins.** A runner is a trust boundary, not just capacity. Do not mix privileged or shell runners with untrusted code, give sensitive projects their own group or project runners, and decide centrally who may register runners (Chapter 9). Runners register with **authentication tokens** (`glrt-...`) created in the UI or API; the legacy registration-token workflow is being phased out.

### The smallest pipeline

```yaml
stages:
  - test

hello:
  stage: test
  image: alpine:3.22
  tags:
    - docker
  script:
    - echo "Hello from $CI_RUNNER_DESCRIPTION"
```

A **job** is any top-level key that is not a reserved keyword. `script` is required, each line is a command, and **a non-zero exit code fails the job**. `image` is the container the job runs in. A job without a stage lands in `test`.

### Keywords you meet in every pipeline

[Docs: keyword reference](https://docs.gitlab.com/19.5/ci/yaml/)

| Keyword | What it does |
| --- | --- |
| `stages` | Order of stages |
| `image`, `services` | Container to run in; extra containers (database, Docker daemon) |
| `script`, `before_script`, `after_script` | The commands. `after_script` runs even on failure |
| `variables` | Environment variables for the job |
| `artifacts`, `cache` | Keep results / speed up dependencies |
| `rules`, `needs` | When a job runs; start as soon as these jobs finish (Chapter 7) |
| `tags` | Pick the runner |
| `allow_failure`, `retry`, `timeout`, `when` | Failure and timing behaviour |
| `environment` | This job deploys to an environment (Chapter 7) |

`default:` sets values for every job (image, tags, retry ...).

### YAML will bite you

```yaml
script:
  - yamllint -d "{extends: relaxed, rules: {line-length: {max: 140}}}" templates/    # WRONG
```

A plain value that contains **`: `** (colon, space) is parsed as a *mapping*, not a string. The linter reports "mapping values are not allowed here", or worse, the line silently means something else.

```yaml
script:
  - 'yamllint -d "{extends: relaxed}" templates/'     # quote the whole line
  - |                                                  # or use a block
    yamllint -d "{extends: relaxed}" templates/
```

Other classics: `yes`/`no`/`on` become booleans, numbers lose leading zeros, tabs are illegal. **Always lint**: the [pipeline editor](https://docs.gitlab.com/19.5/ci/pipeline_editor/) (*Build > Pipeline editor*) and CI Lint do it as you type.

### Predefined variables

[Docs](https://docs.gitlab.com/19.5/ci/variables/predefined_variables/)

GitLab sets hundreds of `CI_*` variables in every job. Print them once (`env | sort | grep ^CI_`) and keep that log as your reference.

| Variable | Use |
| --- | --- |
| `CI_COMMIT_SHA`, `CI_COMMIT_SHORT_SHA` | The commit; image tags |
| `CI_COMMIT_REF_NAME`, `CI_COMMIT_BRANCH`, `CI_COMMIT_TAG` | Branch or tag name |
| `CI_DEFAULT_BRANCH` | `main`: use it in `rules` |
| `CI_PIPELINE_SOURCE` | Why the pipeline runs: `push`, `merge_request_event`, `schedule`, `web`, `api`, `trigger`, `pipeline`, `parent_pipeline` |
| `CI_PROJECT_PATH`, `CI_PROJECT_DIR` | `acme-t1/apps/hello-app`; where the repo is checked out |
| `CI_REGISTRY`, `CI_REGISTRY_IMAGE`, `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD` | The project's registry |
| `CI_JOB_TOKEN`, `CI_SERVER_FQDN` | Short-lived credential; the GitLab host name |

Variables supplied by whoever starts a pipeline (web, API, trigger, schedule) have the **highest priority**, which is why the right to run pipelines with custom variables should be limited.

### Variables: where they come from

[Docs](https://docs.gitlab.com/19.5/ci/variables/) · [Precedence](https://docs.gitlab.com/19.5/ci/variables/#cicd-variable-precedence)

Highest priority first (simplified): **pipeline-run** variables, **project** variables (*Settings > CI/CD > Variables*), **group** variables, **instance** variables (set by an administrator), variables in `.gitlab-ci.yml` (job-level, then global), predefined variables.

Settings on each variable (19.5): **Protect variable** (only on protected branches and tags); **Visibility**: *Visible*, *Masked* (hidden in job logs, **the default since 18.3**) or *Masked and hidden* (also never shown again in the UI; choose it when you create the variable); **Type**: *File* writes the value to a temp file and the variable holds the path; **Expand variable reference**. Project and group variables are 🟢 Free; **environment scope** (a variable only for `production`) is 🟣 Premium.

### Secrets in variables: honest limits

| You use... | Protects against | Does not protect against |
| --- | --- | --- |
| Value in `.gitlab-ci.yml` | Nothing | Anyone who can read the repository |
| Variable | Repository readers | Developers who can change the pipeline |
| **Protected** variable | Feature branches, merge request pipelines | Anyone who can push to a protected branch |
| **Masked** | Accidental printing | A script that sends or encodes the value elsewhere |
| **File** variable | Multi-line secrets (keys) in env | Same as a variable |
| External vault + short-lived tokens | Long-lived leaked credentials (🟣 Premium for the GitLab secrets integration) | A compromised running job during its lifetime |

> [!IMPORTANT]
> **A secret a pipeline can read is a secret the pipeline's author can read.** Make the author list short: protected branches, required approvals 🟣 and code owners on `.gitlab-ci.yml` 🟣 (Chapter 4).

### Artifacts vs cache

[Artifacts](https://docs.gitlab.com/19.5/ci/jobs/job_artifacts/) · [Caching](https://docs.gitlab.com/19.5/ci/caching/)

| | **Artifacts** | **Cache** |
| --- | --- | --- |
| Purpose | Results you need | Speed-up of things you can rebuild |
| Stored | On GitLab | On the runner (or object storage) |
| Passed to later jobs | **Yes**, automatically | Not reliably |
| Downloadable by people | Yes | No |
| Expiry | `expire_in` (default set by admin) | Until evicted |
| Guarantee | Yes | **Best effort** |

```yaml
unit-tests:
  cache:
    key: { files: [requirements-dev.txt] }      # new key = new cache when dependencies change
    paths: [.cache/pip]
  artifacts:
    when: always                                  # keep the report even when tests fail
    expire_in: 1 week
    reports: { junit: report.xml }                # the MR test widget
```

### Reading a failed job

[Docs](https://docs.gitlab.com/19.5/ci/debugging/)

1. **Which job, which stage?** The first red job is usually the cause
2. **Scroll to the first error**, not the last line
3. **Runner problem or script problem?** `Preparing the "docker" executor` and image pull errors are runner or image; your command's output is script
4. **Reproduce locally**: same image, same commands (`docker run --rm -it python:3.13-slim sh`)
5. **Retry** once if it smells like infrastructure (network, rate limit). Check **what changed**: the commit, an updated image tag, an expired variable

Pending forever? **Settings > CI/CD > Runners**: is there a runner with these tags, online and not paused?

### Hands-on: your first pipelines

About 35 minutes, all 🟢 Free. Work in your fork `acme-traineeN/apps/hello-app` (Chapter 4). Because `main` is protected you work on a branch and a merge request, as in real life. The lab instance has one instance-wide runner with the tags `docker` and `linux` (**Settings > CI/CD > Runners**). The pipelines are in [`examples/ci/`](examples/ci/) (in the project: `ci-steps/`). Goal: write and run pipelines of growing size, read job logs, see caching, artifacts and variables behave, and break a pipeline on purpose.

#### 1. The smallest pipeline (6 min)

```bash
cd hello-app && git switch main && git pull && git switch -c ci-basics
cp ci-steps/step1-first-pipeline.yml .gitlab-ci.yml
git add .gitlab-ci.yml && git commit -m "Add the first pipeline" && git push -u origin ci-basics
```

Open a merge request. In **Build > Pipelines** open the job `hello` and read the log from the top: which **runner** ran it, which **image** it pulled, and the output of your `script`. Find `CI_COMMIT_SHORT_SHA`, `CI_PROJECT_PATH`, `CI_PIPELINE_SOURCE` and `CI_REGISTRY_IMAGE`; you use them in Chapter 7.

#### 2. Lint, test, cache, artifacts (10 min)

```bash
cp ci-steps/step2-test-artifacts-cache.yml .gitlab-ci.yml
git commit -am "Lint and test with cache and artifacts" && git push
```

1. Two jobs share a stage and run at the same time. Open `unit-tests` and find *Restoring cache* / *Saving cache*, the pytest output, *Uploading artifacts*. The cache key ends in `-protected` or `-non_protected`: GitLab keeps the caches of protected and unprotected pipelines apart, so an unreviewed branch cannot plant files in a cache that a production pipeline restores later
2. Open the pipeline's **Tests** tab (JUnit report) and the merge request summary. Push an empty commit (`git commit --allow-empty -m retry && git push`): the second run says *Successfully extracted cache*. Compare the durations, and download the **artifact** `report.xml`

#### 3. Break it (5 min)

In `tests/test_app.py` change `assert body["app"] == "hello-app"` to `"hello"`, commit and push. Look at the red pipeline, the merge request warning, and the log (pytest shows the assertion, the file and the line). The **Tests** tab still shows the report although the job failed: why? (`artifacts: when: always`.) Fix the test and confirm it turns green.

#### 4. Variables (6 min)

1. **Settings > CI/CD > Variables > Add variable** (Maintainer role). In 19.5 the form has a **Visibility** choice. Create `GREETING` = `hello` (**Visible**) and `API_TOKEN` = `abc12345xyz` (**Masked**: one line, no spaces, at least 8 characters)
2. Add this job, commit and push:

   ```yaml
   show-variables:
     stage: test
     image: alpine:3.22
     tags: [docker]
     script:
       - echo "GREETING=$GREETING"
       - echo "API_TOKEN=$API_TOKEN"
       - echo "branch=$CI_COMMIT_REF_NAME commit=$CI_COMMIT_SHORT_SHA"
   ```

3. What happened to `API_TOKEN` in the log? (`[MASKED]`. **Masking is a convenience against accidents, not a security boundary**: try `echo "$API_TOKEN" | base64`.)
4. Edit `API_TOKEN` and tick **Protect variable**, push again. What does the log print now? (Nothing: protected variables exist only in pipelines of **protected branches and tags**.) The instance-level `DEPLOY_HOST` is not listed here; you use it in Chapter 7

#### 5. Merge (3 min)

Remove the `show-variables` job (you do not want to print variables on `main`) and merge when green. If you left the approval gates from Chapter 4 on, bob (and alice for her files) must approve first. Look at the pipeline on `main`: it is now the project's baseline.

#### Check yourself

- [ ] You can point at the runner, the image and the script in a job log
- [ ] You saw the cache restored in the second run and know why it is "best effort"
- [ ] A masked variable is hidden in the log; a protected variable is missing on feature branches

#### Questions to discuss

- A job needs a password. Compare: written in `.gitlab-ci.yml`, a variable, a *masked protected* variable, a *File* variable, an external vault. What does each protect against?
- Where would you look when a pipeline stays **pending**? (No runner with the right tags or capacity; runner paused or offline.)
- Add `retry: 1` and `timeout: 5 minutes` to `unit-tests`: when is retrying a bad idea?

---

## Chapter 7: CI in practice

Rules and reuse, then build, push and deploy a Docker application. Everything here is 🟢 Free except protected environments, deployment approvals and environment-scoped variables (🟣 Premium).

### `rules`: should this job exist?

[Docs](https://docs.gitlab.com/19.5/ci/jobs/job_rules/)

Evaluated **top to bottom, first match wins**. No match means the job is **not added** to the pipeline.

```yaml
deploy:
  script: ./deploy.sh
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH     # on main ...
      when: manual                                     # ... but a human presses the button
    - if: $CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/        # on a release tag: automatically
    - when: never                                      # everything else: no
```

| Clause | Use for |
| --- | --- |
| `if` | A condition on variables (`==`, `!=`, `=~` regex, `&&`, `\|\|`) |
| `changes` | Only when these files changed |
| `exists` | Only when a file exists |

`only:` / `except:` are the old syntax; do not mix them with `rules`.

### Branch pipeline or merge request pipeline?

[Docs](https://docs.gitlab.com/19.5/ci/pipelines/merge_request_pipelines/)

```text
 push to branch, no MR yet        ──▶ branch pipeline
 push to branch, MR is open       ──▶ branch pipeline  AND  merge request pipeline   (!)
```

Tell GitLab which one you want:

```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"       # MR open: MR pipeline
    - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS        # MR open: no branch pipeline
      when: never
    - if: $CI_COMMIT_BRANCH                                    # no MR: branch pipeline
    - if: $CI_COMMIT_TAG
```

Merge request pipelines are the ones that gate a merge. The security templates only run in them when `AST_ENABLE_MR_PIPELINES: "true"` is set (Chapter 5). 🟣 Premium *merged results pipelines* and *merge trains* build on this.

### `needs` and `matrix`

[needs](https://docs.gitlab.com/19.5/ci/yaml/#needs) · [matrix](https://docs.gitlab.com/19.5/ci/yaml/#parallelmatrix)

`needs` says exactly what a job waits for, instead of the whole previous stage. `matrix` is one definition, many jobs:

```yaml
package:
  stage: build
  needs: [unit-tests]          # starts as soon as unit-tests is done, not lint

unit-tests:
  image: python:$PYTHON_VERSION-slim
  parallel:
    matrix:
      - PYTHON_VERSION: ["3.11", "3.12", "3.13"]     # three jobs; several variables multiply
```

A matrix costs **runner capacity**: mind how many jobs your runners run at once.

### The reuse ladder

[extends and anchors](https://docs.gitlab.com/19.5/ci/yaml/yaml_optimization/) · [include](https://docs.gitlab.com/19.5/ci/yaml/includes/) · [Components](https://docs.gitlab.com/19.5/ci/components/) 🟢 Free

| Mechanism | What it is | Reach |
| --- | --- | --- |
| YAML anchors `&` `*` | Plain YAML copy | One file |
| **`extends`** | Merge a (hidden) job into another | One pipeline |
| **`!reference`** | Copy one key of another job | One pipeline |
| **`include`** | Pull in another YAML file | Files / projects |
| **Components** | Versioned, parameterised `include` | Whole instance |

`extends` merges hashes deeply, but **arrays (like `script`) are replaced**: use `!reference [.setup, script]` to build a script from pieces. Hidden jobs start with a dot (`.python-job`) and never run on their own. Component usage statistics, and using a GitLab.com component on self-managed, are 🟣 Premium.

### `include` and components

```yaml
include:
  - local: ci/python.yml                                  # same repository
  - project: acme/platform/ci-templates                   # another project
    ref: v2.1.0                                           # tag / branch / SHA - PIN IT
    file: /templates/build.yml
  - template: Jobs/SAST.gitlab-ci.yml                     # shipped with GitLab
  - remote: https://example.com/ci.yml                    # arbitrary URL  <-- be careful
  - component: $CI_SERVER_FQDN/training/ci-components/python-checks@1.0.0
    inputs: { python_version: "3.12" }
```

A **component** is a file in `templates/` of a project with **typed inputs** (`spec: inputs:`) and a **version** after `@`. Inputs are validated before anything runs. See [`examples/ci/components/`](examples/ci/components/) for the two training components.

### Trust in what you include

An included job runs **with your project's credentials and your runner**.

| Reference | You get | Risk |
| --- | --- | --- |
| `@1.0.0` (tag) | What the tag points to | Low if tags are protected |
| `@<commit SHA>` | Exactly that commit | Lowest; update deliberately |
| `@main`, `~latest` | Whatever is there today | The author can change your pipeline silently |
| `remote: https://…` | Whatever the server returns, every time | Unknown author, no history |

Ask of every pipeline you inherit: **what does it include, from where, at which version, and who can change that?** *Build > Pipeline editor > Full configuration* expands everything. Prefer `project` or `component` from **your own** GitLab, pinned to a tag.

> [!NOTE]
> **For owners and admins.** Shared templates and components are code that runs with every consuming project's credentials. Give them their own group, **protect their tags**, require approvals and code owners on them (Chapter 4), and consider owning the pipeline's mandatory parts centrally with pipeline execution policies (🟠 Ultimate, Chapter 9).

### The path of a change

```text
 merge to main
   └─▶ test        lint, unit tests                               (every pipeline)
   └─▶ build       docker build ──▶ Container Registry           image tagged with the commit SHA
   └─▶ deploy      runner ──ssh──▶ Docker host ──pull──▶ registry
                     dev        automatic
                     production manual (and approved, with Premium)
```

**Build once**, deploy the same image everywhere. The image tag says **which commit** it contains. Only configuration differs between environments. A human (or a rule) decides when production changes. The full pipeline is [`examples/ci/step5-build-and-deploy.yml`](examples/ci/step5-build-and-deploy.yml).

### Building images in CI

[Docs](https://docs.gitlab.com/19.5/ci/docker/using_docker_build/)

| Approach | How | Isolation / risk |
| --- | --- | --- |
| **Docker-in-Docker (dind)** | `services: docker:dind`, privileged runner | The job gets its own daemon; the *runner* must be privileged |
| **Socket binding** | Mount the host's `docker.sock` | The job controls the **host's** daemon = root on the runner host |
| **Daemonless builders** | Buildah, BuildKit rootless | No privileged mode; more setup |
| External build service | A dedicated build host, cloud build | Moves the problem elsewhere |

> [!WARNING]
> **Privileged runners only run code you control** (protected branches, trusted projects). Never share them with untrusted merge requests.

```yaml
build-image:
  image: docker:29
  services:
    - docker:29-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
    DOCKER_HOST: tcp://docker:2376
    DOCKER_CERT_PATH: "$DOCKER_TLS_CERTDIR/client"
    BUILDX_NO_DEFAULT_ATTESTATIONS: "1"      # see the note below
  before_script:
    - echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
  script:
    - docker build -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA" .
    - docker push  "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
```

- `CI_REGISTRY_USER` / `CI_REGISTRY_PASSWORD` are created **per job** and expire with it. Pull base images through the group **Dependency Proxy** to avoid Docker Hub rate limits
- `BUILDX_NO_DEFAULT_ATTESTATIONS`: Docker 29 adds attestation manifests to what it builds, and the 19.5 registry rejected them in our lab (`blob unknown to registry`)
- The runner side (`privileged = true`, certificate volume) is set up by whoever owns the runner

### Tagging

| Tag | Meaning | Use |
| --- | --- | --- |
| `:a1b2c3d4` (commit SHA) | **Immutable.** This exact commit | What you deploy |
| `:1.4.2` (release tag) | A released version | Humans, customers |
| `:main`, `:latest` | **Moves** with every build | Convenience, never for deploys |
| `@sha256:…` (digest) | The exact bytes | Strictest pinning |

Bake the version into the image (`ARG APP_VERSION`, OCI labels). Keep SHA tags long enough to **roll back**: the cleanup policy is "keep N", not "delete all but latest".

### Deploying to a Docker host over SSH

```text
  runner (job container)                                 Docker host
  ┌──────────────────────────┐        ssh           ┌────────────────────┐
  │ docker CLI  DOCKER_HOST= │ ───────────────────▶ │ docker daemon      │
  │ ssh://deploy@host:PORT   │   "docker system     │  pulls image from  │
  │ + login to the registry  │    dial-stdio"        │  the registry      │
  └──────────────────────────┘                       └────────────────────┘
```

- The Docker CLI in the job drives the **remote daemon** through SSH; no agent to install
- The Compose file comes from the repository; the **environment** supplies image, port, name. `docker compose up -d --wait` finishes when the healthcheck passes and **fails the job otherwise**
- The key is a **protected File** variable (it must end with a newline) and the host key is **pinned** (Chapter 8)

### Environments 🟢 Free

[Docs](https://docs.gitlab.com/19.5/ci/environments/)

`environment: { name: production, url: ... }` turns a job into a **deployment** that GitLab records.

- **Operate > Environments**: current version, history, who deployed what, from which commit, merge request and pipeline. Dynamic environments: `name: review/$CI_COMMIT_REF_SLUG` with `on_stop` / `auto_stop_in`
- `resource_group: production` makes deployments run one at a time. Environment-scoped variables (same name, different value per environment) are 🟣 Premium

"**What is running in production, and who put it there?**" takes one click. Make sure every pipeline you depend on declares environments.

### Gates

[Protected environments](https://docs.gitlab.com/19.5/ci/environments/protected_environments/) · [Deployment approvals](https://docs.gitlab.com/19.5/ci/environments/deployment_approvals/) · [Deployment safety](https://docs.gitlab.com/19.5/ci/environments/deployment_safety/)

| Control | What it does | Tier |
| --- | --- | --- |
| `when: manual` | A person presses play | 🟢 Free |
| `needs: [deploy-dev]` | Production only after dev succeeded | 🟢 Free |
| Protected branch / tag | Only reviewed code reaches the job at all | 🟢 Free |
| Deployment freeze | No deploys in a time window | 🟢 Free |
| **Protected environment** | Only named roles or users may deploy | 🟣 Premium |
| **Deployment approvals** | N people must approve before the job runs | 🟣 Premium |

`when: manual` alone is a button **anyone with Developer rights** can press. Pair it with a protected environment.

### Rollback

A deployment is "this job, with this image tag, at this time". **Rollback means running an older deployment's job again**: it deploys the old tag, nothing is rebuilt. It works because tags are immutable and the images still exist. Data is the hard part: a rollback of code does not roll back a database migration. Rehearse it once, while nothing is on fire (Hands-on 3.4).

### Going further

#### Parent-child and multi-project pipelines

[Docs](https://docs.gitlab.com/19.5/ci/pipelines/downstream_pipelines/)

```yaml
build-service-a:
  trigger:
    include: services/a/.gitlab-ci.yml       # child pipeline in the same project
    strategy: depend                           # parent waits and takes the result

deploy-docs:
  trigger:
    project: acme/docs/site                    # pipeline in ANOTHER project
    branch: main
```

A **child** splits a big pipeline (monorepo) or runs YAML generated at runtime. A **multi-project** pipeline lets a build in one repo trigger a deployment owned by another team. Cross-project access is governed by the **job token allowlist** and the target's own rules (*Settings > CI/CD > Job token permissions*).

#### A few more keywords for running safely

| Keyword | Use |
| --- | --- |
| `resource_group` | Only one job of the group runs at a time (never two deployments at once) |
| `interruptible` | Safe to cancel when a newer commit arrives (tests yes, deployments no) |
| `workflow:auto_cancel` | Cancel redundant pipelines for the same ref |
| `retry`, `timeout` | Flaky network retries; stop runaway jobs |
| `allow_failure` | A job may fail without failing the pipeline: **ask why** when you see it |

#### Debugging a pipeline you did not write

1. **Build > Pipeline editor > Full configuration**: includes and `extends` resolved. The **Visualize** tab shows the graph before running anything
2. **Lint** (and the CI Lint API): is it valid, and which jobs does it produce for this branch?
3. `CI_DEBUG_TRACE: "true"` prints every command **and expands every variable, including secrets**. Never leave it on, and clean the log if you used it

#### Push or pull deployment?

| Model | Idea | Notes |
| --- | --- | --- |
| **Push (this chapter)** | The pipeline connects to the target and changes it | Simple. The pipeline holds a credential to the target |
| **Pull / GitOps** | An agent *inside* the target watches Git and applies changes | Flux, Argo CD, the [GitLab agent for Kubernetes](https://docs.gitlab.com/19.5/user/clusters/agent/). No inbound credential in CI |
| Auto-pull of images | A tool on the host pulls new tags itself | Easy; weak control over *when* and *what* |

For a handful of Docker hosts, push over SSH is perfectly reasonable if the key is protected and the host is dedicated.

### Hands-on: rules, a shared component, build and deploy

About 45 minutes. Parts 1 and 2 are 🟢 Free (15 min). Part 3 is the full build and deploy (25 min); step 3.6 needs 🟣 Premium. Work in your fork `acme-traineeN/apps/hello-app`, on branches. The deployment target is a Docker host prepared by the trainer: a merge to `main` builds an image, pushes it to the registry and rolls it out over SSH. The first run pulls images and takes a few minutes, so start part 3 early.

#### 1. `rules`, `workflow` and `needs` (8 min) 🟢 Free

```bash
cd hello-app && git switch main && git pull && git switch -c ci-rules
cp ci-steps/step3-rules-needs.yml .gitlab-ci.yml
git add .gitlab-ci.yml && git commit -m "ci: add rules and needs" && git push -u origin ci-rules
```

1. Read the file first: the `workflow:rules` block and the `rules` of `docs-check`, `package` and `release-notes`. Which jobs exist, which do **not**? (`package` and `release-notes` run on the default branch only.)
2. `docs-check` **did** run although you touched no documentation: on the first push of a new branch there is nothing to compare with, so `rules:changes` is true. Edit `README.md` and push again to see the real behaviour
3. Delete the whole `workflow:` block and push: count the pipelines of that commit. You get **two** (a branch and a merge request pipeline). Restore the block

#### 2. A shared component (7 min) 🟢 Free

1. Open `training/ci-components` and read `templates/python-checks.yml`: `spec:inputs:` declares the parameters (with allowed `options`), `$[[ inputs.python_version ]]` is where the value goes. It was **released** as `1.0.0` (**Deploy > Releases**)
2. Use it, then change `python_version` to `"3.12"` and watch the job image change. Try `"2.7"`: the pipeline refuses to start because the value is not allowed

   ```bash
   cp ci-steps/step6-use-components.yml .gitlab-ci.yml
   git add -A && git commit -m "ci: use the shared python component" && git push
   ```

3. **Who can change what this runs?** You pinned `@1.0.0`, a tag. What if the author moves the tag, or you had written `@main`? Whose credentials does the included job use? (Yours.) Debug with **Pipeline editor > Full configuration**

#### 3. Build, push and deploy (25 min) 🟢 Free (step 3.6: 🟣 Premium)

**3.1 What the deployment needs (4 min).** Read `ci-steps/step5-build-and-deploy.yml` before running it. Which jobs exist, in which stages? Which job builds the image and where does it push? How does the deploy job reach the server, which variables does it use? What is the image tag, and why not `latest`? Which deployment is automatic, which needs a human, and what stops production before dev? The trainer set `DEPLOY_HOST`, `DEPLOY_SSH_PORT`, `DEPLOY_USER`, `SSH_KNOWN_HOSTS` and `SSH_PRIVATE_KEY` (a **protected File** variable) once at **instance** level; the same variables could live on a project or group, and the lower level wins.

**3.2 Run it (8 min).**

```bash
git switch main && git pull && git switch -c ci-deploy
cp ci-steps/step5-build-and-deploy.yml .gitlab-ci.yml
git add .gitlab-ci.yml && git commit -m "ci: build and deploy" && git push -u origin ci-deploy
```

1. The merge request pipeline runs **only the test stage**: `build-image` and the deploy jobs have rules for the default branch and tags. When green, **merge** (if you left the Chapter 4 approval gates on, bob must approve first: he owns `.gitlab-ci.yml`)
2. Watch `build-image` (login, build, push), then **Deploy > Container registry**: the tag equals the commit SHA. Watch `deploy-dev` (key, pinned host key, `docker compose ... up -d --wait`; the image is pulled **by the remote server**)
3. Open the `dev` address from **Operate > Environments**: JSON with `"environment": "dev"` and the commit SHA as `version`. A Docker connection error in `build-image` means the runner is not privileged for Docker-in-Docker: tell the trainer

**3.3 Promote one artifact (4 min).** `deploy-prod` waits with a **play** button. Press it and open the production address: `"environment": "production"`, the **same SHA**. Nothing was rebuilt. Change something in `app/main.py`, merge, and let `dev` update: dev runs the new version, production the old one.

**3.4 Roll back (3 min).** Press play on `deploy-prod` of the new pipeline: **Operate > Environments > production** lists two deployments. On the **older** deployment use the re-deploy button: the job re-runs with the **old image tag** and the old `version` is back. This only works because tags are unique and kept.

**3.5 Gates (3 min).** As **alice** (a Developer), can she press `deploy-prod`? Which control is missing between "a Developer can press it" and "only people we named may deploy"?

**3.6 Protect production (3 min) 🟣 Premium.** **Settings > CI/CD > Protected environments**: protect `production`, allowed to deploy **Maintainers**, **1 required approval**. As alice try again. What happens, and who may approve?

#### Check yourself

- [ ] You predicted the jobs of a push correctly, including why `docs-check` appeared
- [ ] You can explain `@1.0.0` against `@main` and why it matters
- [ ] You can point at the registry tag, the environment and the pipeline that produced a deployment
- [ ] You rolled production back to the previous version

#### Questions to discuss

- Your supplier "includes our template from the internet" (`include: remote:`). What could go wrong, and what is the minimum control? (Pin a version, include only from your own GitLab, review changes, restrict who can edit the pipeline file.)
- A deploy job has `rules: - if: $CI_COMMIT_BRANCH == "main"`. Is that what keeps unreviewed code out of production? (No: `rules` only choose jobs. The controls are the **protected branch**, **required approvals** and **protected variables**.)
- The deploy user is in the `docker` group on the server. What can the key therefore do? (Anything: access to the Docker daemon is root on the host.)
- 40 projects share the same `lint` and `test` jobs. Include, component, or template project? Which is easiest to upgrade safely?

#### Stretch

- `step7-matrix-and-child.yml`: three matrix jobs and a child pipeline
- Replace the hand-written build job with the `docker-build` component from `training/ci-components`. What do you lose, and what do you gain?
- Add a temporary environment per merge request: `environment: name: review/$CI_COMMIT_REF_SLUG` with `on_stop` and `auto_stop_in: 1 day`
- Pin the image in the compose file by **digest** instead of tag. When does that matter?

---

## Chapter 8: Security in practice

Secrets, hardening and scanners that actually stop something. Goal: leave with three things people will really do on Monday: look at how their secrets are stored, review the pipeline file like production code, and make the scanners able to say no. The scanners run in 🟢 Free; what GitLab does with the findings is mostly 🟠 Ultimate.

### One sentence to remember

[Docs: pipeline security](https://docs.gitlab.com/19.5/ci/pipeline_security/)

> [!IMPORTANT]
> **A secret a pipeline can read is a secret the pipeline's author can read.**

```text
 who can edit .gitlab-ci.yml  ──▶  what the job runs  ──▶  with which secrets  ──▶  on whose runner
        (Chapter 4)                  (Chapter 7)             (this chapter)           (this chapter)
```

Reviewing the pipeline file is as important as reviewing the application code. Every control below does one of three things: **fewer authors**, **less reach**, or **shorter-lived secrets**.

### Where can a secret live?

[Docs: CI/CD variables](https://docs.gitlab.com/19.5/ci/variables/) · [External secrets](https://docs.gitlab.com/19.5/ci/secrets/)

| Place | Tier | Protects against | Does not protect against |
| --- | --- | --- | --- |
| In the repository | 🟢 Free | Nothing | Everyone with read access, forever (history) |
| CI/CD variable | 🟢 Free | Repository readers | People who can change the pipeline |
| + **Protected** | 🟢 Free | Feature branches, unreviewed pipelines | Anyone who can merge to a protected branch |
| + **Masked** (default) | 🟢 Free | Accidental printing | A script that sends or re-encodes it |
| + **Masked and hidden** | 🟢 Free | Showing the value again in the UI | A running job |
| **File** variable | 🟢 Free | `env` showing it; multi-line secrets | A script reading the file |
| + **Environment scope** | 🟣 Premium | Dev jobs seeing prod values | Whoever deploys there |
| **ID token** (OIDC) with a trust policy | 🟢 Free | Stored long-lived keys | A compromised job, while it runs |
| External manager (`secrets:`) | 🟣 Premium | Secrets sitting in GitLab at all | A compromised job, while it runs |

### Variable settings in 19.5

*Settings > CI/CD > Variables* (Maintainer or higher)

- **Visibility**: *Visible*, **Masked** (default since 18.3), *Masked and hidden* (choose it **when you create** the variable; an existing one cannot be changed to hidden)
- **Protect variable**: only on protected branches and tags. **Type**: *File* writes a temp file and the variable holds the path
- A value can be masked only if it is **one line, no spaces, at least 8 characters**. Output that is *slightly changed* (base64, escaped characters) is **not** masked. The documentation itself warns that masking does not stop a malicious user: use *File* variables and external secrets for real separation

Do **not** put secrets in: Dockerfile `ENV`/`ARG`/`COPY` (`docker history` shows them), repository files, command-line arguments (process lists, logs), artifacts such as `.env`, job logs (`CI_DEBUG_TRACE: "true"` expands every variable). A secret needed **while building** an image goes in with BuildKit `--secret` so it never lands in a layer.

> [!NOTE]
> Changes to group and instance CI/CD variables, and to tokens, are recorded as audit events (🟣 Premium). Who may change a project variable: Maintainers and above; group variables: Owners.

### Fewer authors: pipeline variables

Whoever starts a pipeline can pass variables, and they **win over** the project's variables.

- *Settings > CI/CD > Variables > **Minimum role to use pipeline variables***: `no_one_allowed`, `owner`, `maintainer`, `developer` 🟢 Free. The default is `no_one_allowed` for new projects in new namespaces on GitLab.com and `maintainer` on self-managed when unset. GitLab recommends **pipeline inputs** instead, and disabling pipeline variables once you use inputs
- **Forks**: a fork's pipeline cannot read the parent's variables. Running a fork's merge request pipeline **in the parent** makes **all** of them available: read the `.gitlab-ci.yml` change first ([docs](https://docs.gitlab.com/19.5/ci/pipelines/merge_request_pipelines/))

A Developer who sees `Insufficient permissions to set pipeline variables` is looking at this control working.

### No stored secret: ID tokens

[Docs](https://docs.gitlab.com/19.5/ci/secrets/id_token_authentication/) 🟢 Free

```yaml
deploy:
  id_tokens:
    CLOUD_TOKEN:
      aud: https://cloud.example.com
  script:
    - ./login-with-oidc.sh "$CLOUD_TOKEN"     # exchanges the signed token for short-lived credentials
```

GitLab signs a token that says **who is asking**: project path, branch or tag, whether the ref is **protected**, the environment. The other side trusts rules such as "only `acme/apps/*`, only protected refs, only `production`". There is no long-lived key to leak or rotate, and the reasoning that protects variables (protected refs) now protects the trust relationship. Fetching from Vault and other managers with `secrets:` is 🟣 Premium.

### Rotation and leaving people

Give every secret an **owner** and a **rotation date**, and rotate when someone with access leaves. Prefer **service accounts** 🟢 (or project and group access tokens, whose pages state no tier) over a person's token for automation, and always set an **expiry**. Deploy keys and SSH keys: one per purpose, a **dedicated user** on the target, host key **pinned**, rotated on a schedule and when people leave.

### Harden the pipeline: six questions

| | Question | Controls | Tier |
| --- | --- | --- | --- |
| 1 | **Who can change it?** | Protected `main` with push = No one; required approvals, *prevent approval by creator*; CODEOWNERS on `.gitlab-ci.yml`, `/ci/`, `/deploy/`, `Dockerfile`; protected tags `v*` | 🟢 Free / 🟣 Premium |
| 2 | **What can it reach?** | Protected variables, protected environments, environment scope, pipeline variables restricted, narrow job token allowlist, ID tokens | 🟢 Free / 🟣 Premium |
| 3 | **What does it run?** | Pinned includes (`ref:` tag or SHA, `@1.0.0`), no `remote:`, pinned images (digest for production), no `curl \| sh`, scanners not disabled | 🟢 Free |
| 4 | **Where does it run?** | Know who owns the runner (it sees every secret of every job); privileged only for trusted code; no shell executor or Docker socket for untrusted code; dedicated runners for production | - |
| 5 | **What does it leave behind?** | No secrets in logs, artifacts or image layers; `expire_in` on artifacts; `artifacts: access:` to limit downloads; `environment:` and `resource_group:` on deploys; SHA tags, never `latest` | 🟢 Free |
| 6 | **How does it deploy?** | Protected environment, pinned host key (never `StrictHostKeyChecking=no`), dedicated deploy user and host, key rotation, tested rollback | 🟣 Premium |

Check it works: a feature-branch pipeline cannot read a protected variable (it is simply absent); a Developer cannot start a pipeline with variables; a merge request changing `.gitlab-ci.yml` does not merge without its owner; `grep -rn "password\|token\|secret" .gitlab-ci.yml ci/ deploy/` finds no values.

> [!NOTE]
> **For owners and admins.** Several of these defaults can be set for the whole instance rather than project by project (the minimum role for pipeline variables, enforcing the job token allowlist, whether runners may be registered by members). Chapter 9 lists them with their tiers.

### The job token

[Docs](https://docs.gitlab.com/19.5/ci/jobs/ci_job_token/) 🟢 Free

`CI_JOB_TOKEN` is the credential a job has for GitLab itself. *Settings > CI/CD > **Job token permissions*** holds the **allowlist** of groups and projects that may use your project's resources with their job token.

- By default the allowlist contains **only the project itself**. Add only what is needed
- Adding a **group** covers every project in it, **now and in the future**. Membership and role still apply: the token does not add rights
- Prefer it over a personal token for anything a pipeline does to GitLab

### Scanners: switch on, configure, enforce

[Docs](https://docs.gitlab.com/19.5/user/application_security/)

```yaml
include:
  - template: Jobs/SAST.gitlab-ci.yml                 # Free
  - template: Jobs/Secret-Detection.gitlab-ci.yml     # Free
  - template: Jobs/SAST-IaC.gitlab-ci.yml             # Free
  - template: Jobs/Container-Scanning.gitlab-ci.yml   # Free (needs CS_IMAGE)
  - template: Jobs/Dependency-Scanning.gitlab-ci.yml  # Ultimate
variables:
  AST_ENABLE_MR_PIPELINES: "true"
```

| Scanner | Job name(s) | Useful variables (defaults from the 19.5 templates) |
| --- | --- | --- |
| **SAST** | `semgrep-sast`, per-language jobs | `SAST_EXCLUDED_PATHS` (default `spec, test, tests, tmp`), `SAST_EXCLUDED_ANALYZERS`; 🟠 Advanced SAST: `GITLAB_ADVANCED_SAST_ENABLED: "true"` |
| **Secret detection** | `secret_detection` | `SECRET_DETECTION_EXCLUDED_PATHS`, `SECRET_DETECTION_HISTORIC_SCAN` (whole history, once); clones the last 50 commits by default |
| **Container scanning** | `container_scanning` | `CS_IMAGE` (**required**: the image to scan), `CS_REGISTRY_USER`, `CS_REGISTRY_PASSWORD` |
| **IaC scanning** | `kics-iac-sast` | `SAST_EXCLUDED_PATHS` |
| 🟠 **Dependency scanning** | `gemnasium-*` | `DS_EXCLUDED_PATHS`, `DS_EXCLUDED_ANALYZERS` |

Facts from the templates: jobs land in the `test` stage; they run on your runner and pull analyzer images from GitLab's registry; they are **`allow_failure: true`**; reports are job artifacts downloadable by Developers and above; each can be switched off with a variable such as `SAST_DISABLED`, which **whoever edits the pipeline can also do**. Excluding a path hides findings, it does not fix them: keep exclusions in a reviewed file with a reason.

**Reading the results.** On Free, open the scanner job and download the artifact; each entry has `severity`, `name` and `location.file`: `jq -r '.vulnerabilities[] | "\(.severity) \(.name) \(.location.file)"' gl-sast-report.json`. On Ultimate you get the merge request widget, the pipeline **Security** tab and **Secure > Vulnerability report**; findings on a feature branch are *findings* and become *vulnerabilities* when merged to the default branch.

To scan the image you built, the container scanning job needs its own stage **after** the build: [`examples/ci/step8-scan-built-image.yml`](examples/ci/step8-scan-built-image.yml) (checked against the CI schema only; try it on a test project first).

### A gate you own 🟢 Free

```yaml
security-gate:
  stage: gate
  needs:
    - { job: semgrep-sast,     artifacts: true, optional: true }
    - { job: secret_detection, artifacts: true, optional: true }
  script:
    - |
      failed=0
      for report in gl-sast-report.json gl-secret-detection-report.json; do
        [ -f "$report" ] || continue
        jq -e '[.vulnerabilities[] | select(.severity == "Critical" or .severity == "High")] | length == 0' "$report" || failed=1
      done
      exit $failed
```

- Reads the scanner JSON and **fails** the job (and blocks the merge when pipelines must succeed) on Critical or High. Remember `failed=1`: in a shell loop only the **last** command decides the exit status
- `optional: true` because scanner jobs exist only when there is something to scan. The full version is [`examples/ci/step8-security-gate.yml`](examples/ci/step8-security-gate.yml)
- Limits: SAST, IaC and Advanced SAST all write `gl-sast-report.json`, so use one gate job per scanner job; and **whoever can edit the pipeline can remove the gate**, or disable the scanner

### Enforcement ladder

[Docs: security policies](https://docs.gitlab.com/19.5/user/application_security/policies/)

| Level | What | Who can remove it | Tier |
| --- | --- | --- | --- |
| 1 | People read the findings in review | Nobody notices | 🟢 Free |
| 2 | A gate job in your pipeline | Anyone who can edit the pipeline | 🟢 Free |
| 3 | Pipeline file protected by owner + approvals | Owners | 🟣 Premium |
| 4 | Merge request approval policy | Whoever manages the policy project | 🟠 Ultimate |
| 5 | Scan execution policy | Whoever manages the policy project | 🟠 Ultimate |

Policies are defined **outside** the repository they control, so the people being checked cannot simply delete them in their own merge request.

### Secret detection: layers

[Docs](https://docs.gitlab.com/19.5/user/application_security/secret_detection/) · [Push protection](https://docs.gitlab.com/19.5/user/application_security/secret_detection/secret_push_protection/)

| Layer | Acts | Tier |
| --- | --- | --- |
| `.gitignore`, local pre-commit scan | Before the commit | 🟢 Free |
| Push rule: prevent secret files | At push, by file name | 🟣 Premium |
| **Secret push protection** | At push, by content; blocks | 🟠 Ultimate |
| Pipeline secret detection | After the push | 🟢 Free |
| Historic scan (`SECRET_DETECTION_HISTORIC_SCAN`) | Once over the whole history | 🟢 Free |

**If one leaks:** revoke first, find where it was used, remove it from the repository **and history**, rotate, add the missing layer (Chapter 5).

Common problems: no scanner jobs in a merge request pipeline (set `AST_ENABLE_MR_PIPELINES`); `container_scanning` fails with "image not found" (own stage after the build, check `CS_IMAGE`); green pipeline although findings exist (`allow_failure: true`: add a gate or a policy); `needs` error "job does not exist" (a scanner job is only created when it has files to scan: `optional: true`); secrets in old commits only (default scan covers the last 50 commits).

### Review a pipeline you inherited

Seven questions for whoever runs your pipelines, the same set as the [checklist in Appendix D](#appendix-d-pipeline-review-checklist): where is the file and **who can change it** (is a second person required)? **Which runner**, whose, privileged? Which **secrets**, stored where, readable by whom? How is production **approved**, and is there an **environment** history? How do you **roll back**, and when did you last try? What does it **include**, from where, at which version? Is the image scanned, and can a running container be traced to a **commit**?

**Three things to do on Monday:** open your project's CI/CD variables (which are protected, which are old, who can read them?); read your `.gitlab-ci.yml` with the six questions; check `main` (*Allowed to push*, approvals, code owners on the pipeline file).

### Hands-on: secrets, scanners and a review

About 45 minutes. Steps 1 to 5 work in 🟢 Free; step 6 needs 🟠 Ultimate (the trainer shows it on screen). Work in your fork `acme-traineeN/apps/hello-app`, with `alice` in a private window. Goal: find out what the secret settings really protect, restrict who can inject variables, make the scanners able to fail a pipeline and see how that is bypassed, then review a pipeline you did not write.

#### 1. Protected and masked variables (10 min) 🟢 Free

On a new branch `secrets-test`, use this tiny pipeline:

```yaml
stages: [test]
show:
  stage: test
  image: alpine:3.22
  tags: [docker]
  script:
    - echo "PROD_KEY is '${PROD_KEY:-<not set>}'"
    - echo "encoded: $(echo "$PROD_KEY" | base64)"
    - echo "branch=$CI_COMMIT_REF_NAME protected=$CI_COMMIT_REF_PROTECTED"
```

1. **Settings > CI/CD > Variables > Add variable**: `PROD_KEY` = `s3cr3t-prod-key-123`, Visibility **Masked and hidden**, **Protect variable** ticked. Open it again: can you read the value? Change the Visibility?
2. Push the branch. What does the log say about `PROD_KEY`, and why? (The branch is not protected, so the protected variable is absent.)
3. Untick **Protect variable** and run again. The first line shows `[MASKED]`, the second prints the value **base64-encoded**: masking is "a convenience against accidents". Tick **Protect variable** again
4. Which setting stops a feature branch reading the key? Which stops it being printed? Which stops a reviewer reading it later?

#### 2. Restrict pipeline variables (5 min) 🟢 Free

1. **Settings > CI/CD > Variables**: set **Minimum role to use pipeline variables** to `maintainer`
2. As **alice** (a Developer): **Build > Pipelines > New pipeline**, add a variable `PROD_KEY` = `x`, run it. You should see *Insufficient permissions to set pipeline variables*. Why do pipeline variables have **high precedence**, and why is that dangerous? Leave the setting at `maintainer` or stricter

#### 3. Scanners and a gate you own (15 min) 🟢 Free

Use the insecure code and fake token from Chapter 5 (branch `add-security-scans`; recreate them from Chapter 5 step 3 if needed).

1. `git switch add-security-scans`, then `cp ci-steps/step8-security-gate.yml .gitlab-ci.yml`, commit and push. Find the two `include:` lines, `GATE_FAIL_ON` and the `security-gate` job. Why does every `needs` entry say `optional: true`?
2. The scanner jobs are green, but what does `security-gate` do? Read its log: which findings, at which level?
3. Make it pass **honestly**: remove the token from `config.env` and fix `app/insecure.py` (no `shell=True`, a real password hash). Write down what you would do about a secret already pushed (revoke it)
4. Now **bypass** it like a careless or malicious author: re-add the problems and add `SAST_DISABLED: "true"` and `SECRET_DETECTION_DISABLED: "true"` under `variables:`. The gate **passes**: no scanner ran, so there were no reports. What would have noticed? Consider a code owner on `.gitlab-ci.yml` (🟣), required approvals (🟣), a scan execution policy (🟠)
5. Revert the bypass and set `GATE_FAIL_ON: "Critical High Medium"`. What changes?

#### 4. The job token (5 min) 🟢 Free

**Settings > CI/CD > Job token permissions**: what is on the allowlist by default? (Only the project itself.) Which projects would you add for a pipeline that publishes a package into another project? Would you add a **group**, and what would you give away?

#### 5. Review a pipeline you inherited (10 min)

Open `ci-steps/step9-review-this-pipeline.yml` ([`examples/ci/`](examples/ci/step9-review-this-pipeline.yml)). **Do not run it.** Four minutes alone, three with a neighbour, then the group compares. For each problem write the line, what can go wrong, and the control that fixes it. Use the six questions. Aim for **at least ten**.

<details>
<summary>Answer key (15 findings)</summary>

| # | Finding | Why it matters | Control |
| - | ------- | -------------- | ------- |
| 1 | `include: remote:` from an unpinned URL | Mutable code from the internet runs with your credentials | Copy into your GitLab, include `project` with a tag |
| 2 | Scanner template included, `SAST_DISABLED: "true"` | A scanner that is present but off | No disabling in the pipeline; scan execution policy (Ultimate) |
| 3 | `CI_DEBUG_TRACE: "true"` | Prints every command and expands every variable | Remove |
| 4 | `DB_PASSWORD` in the YAML | In the repository and history | Masked, protected variable or a secrets manager |
| 5 | `IMAGE: ...:latest` | Mutable tag: no traceability, no rollback | Commit SHA tag |
| 6 | `docker:latest`, `docker:dind`, `alpine` unpinned | The build environment changes under you | Pinned versions or digests |
| 7 | `curl ... \| sh` in `before_script` | Arbitrary code from the internet | Pinned download with a checksum |
| 8 | `.env` with the password, kept as an artifact, `expire_in: never` | Secret downloadable for ever | No secret files in artifacts; short expiry |
| 9 | `build` has no `rules` | Every branch builds and pushes `latest`, overwriting the image production uses | Rules for the default branch and tags |
| 10 | No jobs in the `test` stage | Nothing tests before build and deploy | Lint and unit tests |
| 11 | `StrictHostKeyChecking=no` | The key goes to whoever answers | Pinned `known_hosts` |
| 12 | `echo "$SSH_PRIVATE_KEY" > key` from a plain variable | Wrong variable type; key left in the job directory | Protected File variable |
| 13 | `-e DB_PASSWORD=$DB_PASSWORD` on the command line and `echo "... $DB_PASSWORD"` | Visible in process lists and logs | Environment file on the host or a secrets mechanism; never print |
| 14 | `deploy-prod`: `rules: if: $CI_COMMIT_BRANCH, when: manual` | Any branch offers a production deployment; any Developer can press it | Default branch/tag only, protected environment (Premium) |
| 15 | No `environment:`, no `resource_group` | No deployment history, no rollback, parallel deployments | Declare the environment |

</details>

#### 6. What Ultimate adds (5 min) 🟠 Ultimate

The merge request **security widget** lists the findings and **Secure > Vulnerability report** shows what reached the default branch. In **Secure > Policies** read the policy types: where is a policy stored, and which bypass from step 3 does a scan execution policy close? **Secure > Security configuration** shows which scanners are enabled.

#### Check yourself

- [ ] You can name the three different jobs of *protect*, *mask* and *hide*
- [ ] A Developer could not start a pipeline with variables, and you know the setting
- [ ] You made the gate fail, fixed it, and bypassed it
- [ ] You found ten problems in the inherited pipeline

#### Questions to discuss

- The gate passed because the scanners were disabled. How would you design it so it fails when no report exists, and what would that cost?
- A masked secret appeared in a log base64-encoded. What would you change so the job never sees the secret at all? (ID tokens, short-lived credentials, a secrets manager.)
- Who should be allowed to change `.gitlab-ci.yml`, `ci/` and `deploy/` in your team, and is that written anywhere other than in people's heads?
- On Free, what is the strongest enforcement you can build? On Premium? On Ultimate?

---

## Chapter 9: Governance for platform owners

Instance security, user management, locking down access, required approvals at scale, and reporting. This chapter is for the people who **own the platform** or answer for it: administrators, security and compliance. It builds on Chapters 3 and 4 and is written for an enterprise that has to *show* its controls, not only have them.

Plan about 90 to 120 minutes. It does not fit into the two 6-hour days, which are already full: run it as a third half-day, or in the 8-hour variant in place of the optional CI workshops (see [the agenda](#agenda)). A developers-only audience can skip it and read only the **For owners and admins** callouts in Chapters 1 to 8.

> [!IMPORTANT]
> Every setting, tier and limit below was read from the GitLab **19.5** documentation (`19-5-stable-ee`). The lab instance has **no licence**, so only the 🟢 Free settings could be tried; everything 🟣 Premium and 🟠 Ultimate is **documentation-checked, not rehearsed**. Re-read the `Tier:` line of the linked page for your version before you promise a capability to a customer.

### Where a control can be set

[Docs: Admin area](https://docs.gitlab.com/19.5/administration/admin_area/)

The question that matters for governance is not "is there a setting" but **who can undo it**. GitLab enforces most controls at three levels:

| Level | Set by | Typical use | Who below can override |
| --- | --- | --- | --- |
| **Instance** (Admin area, self-managed) | Administrators | Defaults and hard limits for everyone | Nobody, when the setting *locks* (approval settings, job token allowlist enforcement) |
| **Group** (top-level group) | Group Owners | Rules for all projects of a business unit | Project Maintainers, **unless** the setting is a locking one |
| **Project** | Maintainers | Day-to-day working rules | The project's own Maintainers and Owners |
| **Policy** 🟠 | Whoever manages the *security policy project* | Rules the project cannot remove | Not the project |

Read each control in this chapter with that column in mind. A setting that a project Maintainer can switch off is a convenience, not a control (Chapter 5).

### Administrators, and what they can do

[Docs: Admin Mode](https://docs.gitlab.com/19.5/administration/settings/sign_in_restrictions/) · [Auditor users](https://docs.gitlab.com/19.5/administration/auditor_users/)

- **Keep the number of administrators small**, and give each one a personal account (this course's instance renames the built-in `root` to a named admin). Enforce 2FA for them first
- **Admin Mode** 🟢 Free: administrators have no admin rights in their session until they authenticate again for admin tasks. It applies to all administrators, **times out after six hours, and the timeout cannot be changed**
- **Impersonation** lets an administrator act as any user, including other administrators. It is **enabled by default**, can be turned off, and **every impersonation is recorded** as an audit event (`user_impersonation`)
- **Auditor user** 🟣 Premium: read-only access to all groups and projects, with no Admin area and no administration actions. It uses a licence seat, and because of a known issue it needs at least the Reporter role to do read-only tasks. Give auditors this instead of Owner
- **Break-glass** access (an account that bypasses the controls) should be rare, named, logged and reviewed (Chapter 4)

### Lock down the instance

[Sign-up](https://docs.gitlab.com/19.5/administration/settings/sign_up_restrictions/) · [Visibility and access](https://docs.gitlab.com/19.5/administration/settings/visibility_and_access_controls/) · [Account and limits](https://docs.gitlab.com/19.5/administration/settings/account_and_limit_settings/) · [Sign-in](https://docs.gitlab.com/19.5/administration/settings/sign_in_restrictions/) · [2FA](https://docs.gitlab.com/19.5/security/two_factor_authentication/)

*Admin > Settings*. Tiers are those of the page or section that documents the setting.

| Goal | Setting | Tier |
| --- | --- | --- |
| Nobody creates an account on their own | **Sign-up** off. By default **any user visiting your domain can create an account**. Add *Require admin approval for new user accounts* (on by default for new instances), a *user cap*, an e-mail *allowlist or denylist* of domains, password complexity | 🟢 Free |
| Promotions to a billable role are approved | *Administrator approval for role promotions* | 🟠 Ultimate |
| Nothing is public by accident | *Restricted visibility levels*, *Default project / group visibility* (a restricted level cannot be the default) | 🟢 Free |
| Not everyone creates projects | *Default minimum role required to create projects*; who may create groups | 🟢 Free |
| Projects are not deleted casually | *Allowed to delete projects*: administrators only | 🟣 Premium |
| Only strong keys | *SSH key types and minimum lengths* | 🟢 Free |
| No eternal credentials | *Require expiration dates for new access tokens* | 🟢 Free |
| | *Limit the lifetime of access tokens* and *of SSH keys* (self-managed and Dedicated) | 🟠 Ultimate |
| Everyone uses a second factor | *Enforce two-factor authentication*, with a grace period in hours (`0` enforces at the next sign-in); administrators can be enforced separately | 🟢 Free |
| Weak sign-in paths are closed | Turn off *password authentication* for the web interface or for Git over HTTP(S) when you use SSO or tokens | 🟢 Free |
| Sessions end | *Session duration (minutes)* (`0` breaks the instance) | 🟢 Free |
| Idle accounts do not linger | *Deactivate dormant users* after a period of inactivity (minimum and default 90 days) | 🟢 Free |
| Users cannot delete their accounts or rename themselves | *Prevent users from deleting their accounts*, *Disable user profile name changes* | 🟣 Premium |
| Only the network you allow | Per-group **IP address restriction** (see below). The instance-level *Globally-allowed IP ranges* is **not** a lock-down: it is an exception list so that components such as GitLab Pages keep working when groups restrict IPs | 🟣 Premium (groups) |
| Abuse is slowed down | *User and IP rate limits*, *Protected paths* (sign-in and similar, 10 POST and 10 GET requests per minute per IP by default), *Outbound requests* (webhooks to the local network are blocked by default) | 🟢 Free |
| Imports and exports are controlled | *Import sources*, *Project export* | 🟢 Free |

> [!WARNING]
> **Group IP restriction depends on a correct `X-Forwarded-For`.** To limit IP spoofing the server that receives user requests must **overwrite**, not append, `X-Forwarded-For`. A reverse proxy that trusts the client's header turns this control into theatre. Check it with a test from an address you did not allow.

> [!CAUTION]
> Think before you change these on a shared or training instance. *Enforce two-factor authentication* sends every user, including you, into 2FA setup at the next sign-in; a restricted visibility level can break projects that already use it; a session duration of `0` breaks the instance.

#### CI/CD settings that belong to the platform owner

[Docs](https://docs.gitlab.com/19.5/administration/settings/continuous_integration/) 🟢 Free

*Admin > Settings > CI/CD*. These are the instance-wide versions of the controls in Chapter 8:

| Setting | Why |
| --- | --- |
| **Allow pipeline variables by default in new groups** (off recommended) | When off, the *minimum role to use pipeline variables* is **No one allowed** for new groups and the projects in them. Off is the secure default |
| **Protect CI/CD variables by default** | Every new variable is protected: available only on protected branches and tags |
| **Enable and enforce job token allowlist for all projects** | CI/CD job tokens can access a project only when the token's source project is on its allowlist; the setting cannot be switched off by project Maintainers |
| **Runner registration**: clear *Allow runner registration token* and *Members of the project / group can create runners* | By default registration tokens and member registration are allowed. The documentation calls registration tokens **legacy and not recommended**: use runner authentication tokens, which give traceability of runner ownership |
| *Enable instance runners for new projects*, default artifact expiry | Decide who gets shared capacity and how long results live |

#### See your own settings (read only)

With an administrator's personal access token (scope `read_api`), this prints the values that matter. It changes nothing:

```bash
curl --silent --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "https://<gitlab-host>/api/v4/application/settings" | jq '{
  signup_enabled, require_admin_approval_after_user_signup,
  restricted_visibility_levels, default_project_visibility, default_group_visibility,
  require_two_factor_authentication, two_factor_grace_period,
  password_authentication_enabled_for_web, password_authentication_enabled_for_git,
  admin_mode, session_expire_delay, deactivate_dormant_users,
  require_personal_access_token_expiry, max_personal_access_token_lifetime,
  max_ssh_key_lifetime, allow_runner_registration_token }'
```

Tested on a 19.5.3 instance: a token with only `read_api` is enough (it could read the settings and was refused when it tried to create a group). The Ultimate-only limits, `max_personal_access_token_lifetime` and `max_ssh_key_lifetime`, come back `null` without a licence. The values a fresh instance showed, for comparison: `two_factor_grace_period` 48 hours, `session_expire_delay` 10080 minutes (7 days), `deactivate_dormant_users` off, `require_personal_access_token_expiry` on, `allow_runner_registration_token` on.

### User management and identity

[Roles](https://docs.gitlab.com/19.5/user/permissions/) · [Custom roles](https://docs.gitlab.com/19.5/user/custom_roles/) · [Moderating users](https://docs.gitlab.com/19.5/administration/moderate_users/)

**Roles.** Guest, Planner, Reporter, Developer, Maintainer, Owner, plus 🟣 **Minimal Access** (see the group, nothing inside) and 🟠 **custom roles** (pick the exact permissions; you must have fewer than 10; an Auditor access level exists). A **Security Manager** role exists in 19.5 as a **beta, disabled by default**. Least privilege means the lowest role that does the job, granted on a group, reviewed on a schedule (Chapter 3).

**One identity provider, no local accounts.**

| Capability | Tier |
| --- | --- |
| [SAML SSO for the instance](https://docs.gitlab.com/19.5/integration/saml/) (self-managed) | 🟢 Free |
| [SAML SSO for a group](https://docs.gitlab.com/19.5/user/group/saml_sso/) (GitLab.com), with *SAML group sync* | 🟣 Premium |
| [SCIM provisioning](https://docs.gitlab.com/19.5/administration/settings/scim_setup/) (self-managed and Dedicated): create, block and re-add users from the IdP | 🟣 Premium |
| [LDAP](https://docs.gitlab.com/19.5/administration/auth/ldap/), [OpenID Connect](https://docs.gitlab.com/19.5/administration/auth/oidc/) | 🟢 Free |
| [Enterprise users](https://docs.gitlab.com/19.5/user/enterprise_user/): accounts claimed and managed by a top-level group with a verified domain | 🟣 Premium |

Two cautions from the documentation: with OpenID Connect, if `required_groups` is empty **any user the IdP authenticates can use GitLab**; and **deprovisioning through SCIM blocks the user (`active: false`) but does not remove the linked SAML identity**.

**Group-level access controls** (🟣 Premium, [docs](https://docs.gitlab.com/19.5/user/group/access_and_permissions/)): restrict access by **IP address**, restrict by **e-mail domain**, **prevent project forking outside the group**, and **prevent members from being added to projects** (a membership lock, useful to freeze a group during an audit). *Prevent users from requesting access to a group* is 🟢 Free.

**Machine identities** ([token overview](https://docs.gitlab.com/19.5/security/tokens/)):

| Credential | Belongs to | Notes |
| --- | --- | --- |
| Personal access token 🟢 | A person | Expiry required by default; the administrator can cap the lifetime (🟠) |
| [Service account](https://docs.gitlab.com/19.5/user/profile/service_accounts/) 🟢 | A non-human user | Prefer it for automation; deleting one keeps contributions (moved to a ghost user) |
| Project / group access token | A bot user on a project or group | The pages state **no tier**: check yours |
| [Deploy token](https://docs.gitlab.com/19.5/user/project/deploy_tokens/) 🟢 | A project or group, not a user | No expiry by default: set one. Cannot be used with the API |
| [Deploy key](https://docs.gitlab.com/19.5/user/project/deploy_keys/) 🟢 | One user | **Rejected when its owner is blocked** |

🟠 **Credentials inventory** ([docs](https://docs.gitlab.com/19.5/administration/credentials_inventory/)) lists tokens and keys for audit and revocation.

#### Joiner, mover, leaver

An auditor will ask how fast access disappears when someone leaves. Know what each action does ([moderating users](https://docs.gitlab.com/19.5/administration/moderate_users/), [deleting a user](https://docs.gitlab.com/19.5/user/profile/account/delete_account/)):

| Action | Effect | Use for |
| --- | --- | --- |
| **Block** | Cannot sign in or access any repositories; data is kept | A leaver, a suspected compromise |
| **Deactivate** | Does not occupy a seat; signing in reactivates the user | Inactive accounts (also automatic for dormant users) |
| **Ban** | Block, and hide the user's activity from the instance | Spam or abuse |
| **Delete user** | Deletes the personal projects; contributions move to a ghost user | After retention is satisfied |
| **Delete user and contributions** | Also removes the user's records, groups where they are the sole owner, and personal access tokens | Rarely: removes more than you may intend |

> [!NOTE]
> **Recommended practice, not from the documentation:** drive joiners and leavers from the identity provider (SSO plus SCIM), not from GitLab; block first, delete later; transfer group ownership before a leaver's account goes; and keep the ticket and the audit event as evidence. The page on moderating users does not say what happens to a blocked user's tokens and SSH keys, so test it on your version and write the answer into the runbook.

### Required approvals and change control across many projects

[Approval settings](https://docs.gitlab.com/19.5/user/project/merge_requests/approvals/settings/) · [Instance settings](https://docs.gitlab.com/19.5/administration/merge_requests_approvals/) · [Group settings](https://docs.gitlab.com/19.5/user/group/manage/#group-merge-request-approval-settings)

Chapter 4 set approvals *per project*, where a Maintainer can weaken them. Governance asks for the opposite: **set once, locked below.**

| Control | Where it can be set | Locked below? | Tier |
| --- | --- | --- | --- |
| **Approval settings** (prevent author approval, prevent approval by committers, prevent editing rules, remove approvals on new commits) | Instance, top-level group, project | **Yes**. An instance setting locks the equivalent setting in all groups and projects. An enabled group setting locks the project setting ("Project Maintainers cannot change it"); a disabled one leaves it to each project. The instance version of *prevent editing approval rules* goes further than the group and project ones: it also locks the **approval rules list in project settings** | 🟣 Premium |
| **Approval rules** (how many, from whom) | **Project only**. Setting rules for a group is not available (tracked as an open epic) | No | 🟣 Premium |
| **Protected branches** | Project; a **group's** protected branches apply to all projects in a top-level group and cannot be changed in a project (subgroups are not supported) | Group: yes | Project 🟢 Free, group 🟣 Premium |
| **Default branch protection** for new projects | Instance (Admin area) | Default only | 🟢 Free |
| **Code owner approval** on a protected branch | Project | No | 🟣 Premium |
| **Push rules** | Project; group and instance rules are a **template for new projects only** and do not change existing ones | No: deleting project push rules leaves none | 🟣 Premium |
| **Protected environments** | Project; group-level protection by deployment tier, and a subgroup cannot override its parent | Group: yes | 🟣 Premium |
| **Security policies** | The security policy project, linked to a group or project | **Yes, outside the repository** | 🟠 Ultimate |

#### Security policies 🟠 Ultimate

[Docs](https://docs.gitlab.com/19.5/user/application_security/policies/)

Policies are YAML in a **security policy project** (`.gitlab/security-policies/policy.yml`) that you link to groups or projects (*Secure > Policies*). To link one you need the **Owner** role on the group or project, or a custom role with the `manage_security_policy_link` permission. The people being checked do not hold that role, which is the whole point.

| Policy type | What it enforces | Notes |
| --- | --- | --- |
| [Merge request approval](https://docs.gitlab.com/19.5/user/application_security/policies/merge_request_approval_policies/) | Approvals, based on scan results, in every project in scope | Up to 5 rules per policy and 5 policies per policy project. Supports **bypass settings** (for branches, service accounts, users, groups, roles) with a reason, and a **warn mode** that shows the violation without blocking |
| [Scan execution](https://docs.gitlab.com/19.5/user/application_security/policies/scan_execution_policies/) | Scans run whatever the project's pipeline says | Local project YAML **cannot override** it. Up to 10 actions per policy. Updates pushed straight to the policy file can take up to 10 minutes to propagate |
| [Pipeline execution](https://docs.gitlab.com/19.5/user/application_security/policies/pipeline_execution_policies/) | Injects or replaces CI/CD configuration in targeted projects | Strategies `inject_policy` and `override_project_ci` (`inject_ci` is deprecated). Do not store secrets in policy variables: they are plaintext in Git |
| [Vulnerability management](https://docs.gitlab.com/19.5/user/application_security/policies/vulnerability_management_policy/) | Automatically resolves vulnerabilities no longer detected on the default branch | |

> [!WARNING]
> **Compliance pipelines are deprecated** (since 17.3, planned removal in 20.0) and replaced by pipeline execution policies. Do not enable pipeline execution policies in a project until you have migrated an existing compliance pipeline there: both configured means the compliance pipeline replaces the project pipeline.

#### Compliance frameworks 🟣 Premium

[Docs](https://docs.gitlab.com/19.5/user/compliance/compliance_frameworks/) · [Compliance center](https://docs.gitlab.com/19.5/user/compliance/compliance_center/)

A framework is a label on projects (for example "SOC 2 in scope") that reports and policies can target. Creating one **from a template**, and defining **requirements** with controls, is 🟠 Ultimate. The templates (generally available since 19.1) include **SOC 2**, **ISO 27001:2022**, **NIS 2**, **DORA**, **NIST 800-53 Rev. 5**, **FedRAMP**, **CIS CSC** and **TISAX**. The SOC 2 template maps requirements to COSO principles and covers vulnerability scanning, access controls and change management: a starting list, **not a substitute for your own control set**. GitLab checks controls; it does not make anyone compliant.

### Reporting and evidence

An audit is won with records produced by the normal workflow (Chapter 4). What to use for which question:

| Question | Report | Tier | Caveats from the docs |
| --- | --- | --- | --- |
| Who changed which setting, when? | [**Audit events**](https://docs.gitlab.com/19.5/user/compliance/audit_events/): instance (*Admin > Monitoring > Audit events*, self-managed, [docs](https://docs.gitlab.com/19.5/administration/compliance/audit_event_reports/)), group (Owner), project (Maintainer) | 🟣 Premium | **Retained indefinitely.** UI and API date range is limited to **30 days** per query; CSV export uses UTC |
| Keep them outside GitLab | [Audit event streaming](https://docs.gitlab.com/19.5/user/compliance/audit_event_streaming/) (top-level groups) and [for instances](https://docs.gitlab.com/19.5/administration/compliance/audit_event_streaming/); HTTP endpoint and cloud destinations, up to 20 custom headers | 🟠 Ultimate | May deliver an event more than once: deduplicate on `id` |
| Pull events into a SIEM | [Audit events API](https://docs.gitlab.com/19.5/api/audit_events/) | 🟣 Premium | Same 30-day window per query |
| Which actions are recorded? | [Audit event types](https://docs.gitlab.com/19.5/user/compliance/audit_event_types/) | 🟣 Premium | Recorded: approval rule created, updated or deleted, protected environment rules, group membership lock, group and project push rules, impersonation, Admin Mode, application settings, token creation. **Not stored: "a merge request is approved"** (the merge request is the evidence) and merge request creation |
| Which projects meet their framework's controls? | [Compliance center](https://docs.gitlab.com/19.5/user/compliance/compliance_center/): projects, frameworks, **violations** and **status** reports | Center 🟣 Premium; violations and status 🟠 Ultimate | Scans run when a framework is added, when requirements change, and every 12 hours. Seen by administrators, Security Managers and group Owners |
| What is vulnerable, and is it being handled? | [Vulnerability report](https://docs.gitlab.com/19.5/user/application_security/vulnerability_report/), [security dashboard](https://docs.gitlab.com/19.5/user/application_security/security_dashboard/) | 🟠 Ultimate | The dashboard shows open vulnerabilities from the default branch only |
| What credentials exist? | [Credentials inventory](https://docs.gitlab.com/19.5/administration/credentials_inventory/) | 🟠 Ultimate | |
| Who has access? | **Members** per project and group; [export members as CSV](https://docs.gitlab.com/19.5/user/group/manage/) | CSV 🟣 Premium | Evidence for access reviews |
| How is the platform used? | [Usage trends](https://docs.gitlab.com/19.5/administration/analytics/usage_trends/) | 🟢 Free | Administrators |
| How fast and how safely do we deliver? | [DORA metrics](https://docs.gitlab.com/19.5/user/analytics/dora_metrics/) | 🟠 Ultimate | |
| Where does work wait? | [Value stream analytics](https://docs.gitlab.com/19.5/user/group/value_stream_analytics/) | 🟢 Free | Aggregation needs Premium or Ultimate |
| Who contributes, and how fast do merge requests merge? | [Contribution analytics](https://docs.gitlab.com/19.5/user/group/contribution_analytics/) and [merge request analytics](https://docs.gitlab.com/19.5/user/analytics/merge_request_analytics/) | 🟣 Premium | |
| Is the runner fleet healthy? | [Runner fleet dashboard](https://docs.gitlab.com/19.5/ci/runners/runner_fleet_dashboard/) | 🟠 Ultimate | Beta |
| Is the server healthy, and what do the logs say? | [Logs](https://docs.gitlab.com/19.5/administration/logs/) (`audit_json.log` and others, for your SIEM), [health checks](https://docs.gitlab.com/19.5/administration/monitoring/health_check/), [Prometheus](https://docs.gitlab.com/19.5/administration/monitoring/prometheus/) | 🟢 Free | Health endpoints answer only allow-listed addresses |

#### Evidence a development team can produce on demand

Keep the way to produce each item **repeatable**, and ask the compliance owner which format the auditor wants.

| Evidence | How | Tier |
| --- | --- | --- |
| Branch protection and approval settings, with their change history | Branch rules page or API, plus audit events for the period | Settings 🟢 Free, history 🟣 Premium |
| A sample of merged MRs with approvals and pipeline results | MR list filtered by merge date; the merge request API | 🟢 Free (view), 🟣 (approvals) |
| `CODEOWNERS` and its history | `git log -- .gitlab/CODEOWNERS` | 🟣 Premium to enforce |
| Who has access, by role, at a point in time | Members, member API, export | 🟢 Free / 🟣 CSV |
| Access was reviewed (for example quarterly) | A ticket per review with the member list attached | 🟢 Free |
| Leavers lost access | Membership audit events next to the HR list | 🟣 Premium |
| Scan results over time | Job artifacts; vulnerability report; scan execution policy settings | 🟢 artifacts, 🟠 report and policies |
| Production deployments and who approved them | Environments page and deployment approvals | 🟢 deployments, 🟣 approvals |

**Findings that are common in practice** (practitioner experience, not GitLab; your auditor's list will differ): a production change without the required approval (often an emergency); an administrator or bot account that can push to the protected branch; approvers who were no longer authorised; access not removed in time after someone left; scanner findings with no triage or owner; settings changed during the period without a ticket; shared accounts and tokens that never expire; evidence that lives only in people's heads or chats.

**What GitLab cannot do.** GitLab's own SOC 2 report is about GitLab's operations, not about your use of it. On a **self-managed** instance you operate the server: patching, backups, access to the host and the administrator account are **your** controls. Settings do not replace policies, risk assessment, onboarding and offboarding, vendor management or incident response. And a configuration can be switched off by someone with enough rights, which is why audit events and a reviewed history of changes to the settings matter as much as the settings.

### Tier reference for this chapter

| Capability | Tier |
| --- | --- |
| Sign-up, visibility, 2FA enforcement, Admin Mode, dormant users, rate limits, CI/CD instance settings, LDAP, OIDC, instance SAML, service accounts, usage trends | 🟢 Free |
| Group IP and domain restriction, approval settings cascade, group protected branches, push rules, Auditor user, SCIM, group SAML, enterprise users, audit events (group and project), audit API, compliance center, compliance frameworks, protected environments, restrict project deletion, members export | 🟣 Premium |
| Custom roles, security policies, framework templates and requirements, compliance violations and status reports, audit event streaming, vulnerability report and dashboard, credentials inventory, token lifetime limits, role promotion approval, DORA, runner fleet dashboard | 🟠 Ultimate |

### A 30-day hardening plan

A suggested order of work, built from the controls above. It is a recommendation, not a documented procedure: adapt it to your risk and your tier.

| Week | Do | Why first |
| --- | --- | --- |
| 1 | Inventory administrators and enforce 2FA for them; turn on Admin Mode; sign-up off or approval on; restricted visibility; read the settings snapshot above and keep it as the baseline | Cheapest controls, biggest exposure |
| 2 | Single sign-on and provisioning (SAML or OIDC, SCIM 🟣); token expiry required and lifetimes capped (🟠); deactivate dormant users; list and clean up tokens and deploy keys | Identity is the root of every other control |
| 3 | Protected default branches everywhere (group level 🟣); approval settings locked at the instance or top-level group 🟣; code owners on pipeline and deploy files 🟣; pipeline variables restricted, job token allowlist enforced, runner registration closed | Change control that a Maintainer cannot weaken |
| 4 | Security policies for the controls that must not be removable 🟠; compliance frameworks and the compliance center 🟣/🟠; audit event streaming to your SIEM 🟠; write the evidence runbook and rehearse one audit sample | Enforcement and evidence |

### Hands-on: review a platform against this chapter

About 60 to 90 minutes, as a workshop around one instance (the trainer's, or the participants' own). Settings are read, not changed, unless you have a sandbox.

1. **Read your settings** (15 min). Run the read-only snippet above with an administrator token, or open the pages *Admin > Settings > General* and *CI/CD*. Fill in a table: setting, current value, target value, tier needed, owner. Which three gaps are cheapest to close?
2. **Walk a leaver** (15 min). On a sandbox, create a user, add them to a group and a project, create a personal access token and an SSH key for them. Block the user. What can they still do? What happens to the deploy key they owned and to their token? Write the answers into a runbook (the documentation does not say, so *test it*)
3. **Prove a lock** (15 min, 🟣 trial needed). Set an approval setting on a group and look at the same setting in a project: is it locked? Can a Maintainer change it? Then look for the audit event
4. **Map a control to evidence** (15 min). Take the SOC 2 row "changes are authorised, tested and approved before release" from Chapter 4 and list, for your instance, the setting that enforces it, the level it is set at, who can undo it, and the report that proves it for a past period
5. **Decide the policy** (15 min, 🟠 discussion). Which one control would you put in a security policy project because a Maintainer must not be able to remove it?

#### Questions to discuss

- Who in your company can change a protected branch rule, and where would you see that they did?
- A project Maintainer wants to disable *prevent approval by author* "just for the release". Which of your controls says no, and who says yes?
- How long does a leaver keep access to GitLab today, and how would you prove it to an auditor?

---

## Appendix A: Git cheat sheet

Plain Git, no tier needed. The scenarios to practise on are in [`examples/git-exercises/`](examples/git-exercises/).

- A **commit** is a snapshot with a parent. A **branch** is a movable label on a commit. **HEAD** is where you are
- Three areas: **working tree** (files) - **index** (what the next commit contains) - **repository** (commits)
- `origin/main` is your **last known copy** of the server's `main`; it moves only when you `fetch`
- Committed work is recoverable; unsaved edits are not. One purpose per commit; the subject is imperative, about 50 characters; the body says **why**

```bash
git status -sb                      # the command to run when unsure
git log --oneline --graph --all     # the shape of the repository
git diff / git diff --staged        # working tree vs index / index vs last commit
git blame <file>   git log -S"text" # who changed each line / commits where "text" count changed
git config --list --show-origin     # every setting and the file it came from

git add -p                          # stage hunks, not whole files
git commit -m "feat(cart): add discounted()" -m "Closes #12"
git switch -c 123-short-name        # create and move
git fetch                           # safe; git pull = fetch + merge (or rebase)
git push -u origin 123-short-name   # first push of a branch
git push --force-with-lease         # after rewriting YOUR branch only

git merge feature   git merge --abort
git rebase main     git rebase --continue | --abort     # only YOUR commits, never shared ones
```

| I want to... | Command |
| --- | --- |
| Throw away edits to a file | `git restore <file>` (edits are lost) |
| Unstage a file | `git restore --staged <file>` |
| Fix the last commit | `git commit --amend` |
| Undo a commit that is **pushed** | `git revert <commit>` (adds a new commit) |
| Drop local commits, keep / lose the changes | `git reset --soft HEAD~2` / `git reset --hard HEAD~2` (dangerous) |
| Park unfinished work | `git stash push -u` ... `git stash pop` |
| Get "lost" commits back | `git reflog`, then `git branch rescue <commit>` or `git reset --hard HEAD@{n}` |
| Copy one commit elsewhere | `git cherry-pick -x <commit>` |
| Find the commit that broke it | `git bisect start; git bisect bad; git bisect good <ok>; git bisect run ./test.sh; git bisect reset` |

Habits: commit often; `git status` and `git branch backup` before something risky; never rebase or force-push a branch other people use; a committed secret is compromised, so **revoke it first**; `.gitignore` from the first commit.

## Appendix B: GitLab and CI cheat sheet

Menu names are for GitLab 19.5.

```bash
git switch main && git pull
git switch -c 123-short-description
git add -A && git commit -m "Say what and why" -m "Closes #123"
git push -u origin 123-short-description        # then open the merge request
```

| Menu | Entries |
| --- | --- |
| Manage | Activity, **Members**, Labels |
| Plan | **Work items**, Issue boards, Milestones, Wiki |
| Code | **Merge requests**, Repository, Branches, Commits, Tags |
| Build | **Pipelines**, Jobs, **Pipeline editor**, Pipeline schedules, Artifacts |
| Secure | Audit events, Security configuration (more with a licence) |
| Deploy | Releases, Package registry, **Container registry** |
| Operate | **Environments** |
| Settings | General, Access tokens, **Repository** (branch rules, deploy tokens), Merge requests, **CI/CD** (variables, runners), Packages and registries |

```yaml
stages: [test, build, deploy]

workflow:                               # one pipeline per change
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS
      when: never
    - if: $CI_COMMIT_BRANCH
    - if: $CI_COMMIT_TAG

default:
  image: python:3.13-slim
  tags: [docker]

unit-tests:
  stage: test
  cache: { key: { files: [requirements-dev.txt] }, paths: [.cache/pip] }
  script:
    - pip install -r requirements-dev.txt
    - pytest --junitxml=report.xml
  artifacts: { when: always, expire_in: 1 week, reports: { junit: report.xml } }

deploy:
  stage: deploy
  environment: { name: production, url: "https://example.com" }
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: manual
  script: [./deploy.sh]
```

| Keyword | Meaning |
| --- | --- |
| `stages`, `stage` | Order of groups of jobs |
| `image`, `services` | Container the job runs in; helper containers |
| `script`, `before_script`, `after_script` | The commands; a non-zero exit fails the job |
| `rules`, `workflow:rules` | Does the job / the pipeline exist? First match wins |
| `needs` | Start as soon as these jobs are done |
| `extends`, `!reference`, `include`, `component` | Reuse |
| `artifacts` / `cache` | Keep results / speed up dependencies |
| `variables`, `environment`, `resource_group` | Settings, deployment record, one at a time |
| `allow_failure`, `retry`, `timeout`, `when: manual` | Failure and timing behaviour |
| `parallel:matrix`, `trigger` | Many jobs from one; child and multi-project pipelines |

Quick actions: `/assign @alice  /reviewer @bob  /label ~bug  /milestone %"v1"  /estimate 2h  /spend 30m  /due tomorrow  /draft  /ready  /close  /merge`. A YAML trap: a plain value containing `: ` becomes a mapping, so quote the line.

## Appendix C: Tier reference

Which GitLab tier each feature in this course needs.

- **Free**: available in all tiers. **Premium**: Premium **and** Ultimate. **Ultimate**: Ultimate only
- On GitLab.com and on self-managed GitLab the tier of a feature is the same unless a row says otherwise. Self-managed EE without a licence behaves as Free; an Ultimate trial unlocks everything for 30 days
- **Version: GitLab 19.5.** The chapters 1 to 8 were checked on 2026-11-08, the governance rows on 2026-11-09. Method: the `Tier:` lines (page and sections) of about 150 pages of the raw documentation of the `19-5-stable-ee` branch, read page by page; for features in the product's licensed-feature lists the two sources were also compared and agreed. Where a page has one tier for the page and a higher tier for a section, both are listed
- **Tiers change between releases.** Open the page on docs.gitlab.com for your version: the tier is the first thing under the title
- **"Not stated"** means the page has no `Tier:` line (it lists only the offering). That is **not** evidence that the feature is Free: check it in your own tier before relying on it

### Git and code collaboration

| Feature | Tier | Notes |
| --- | --- | --- |
| Repository, branches, tags, merge requests, Web IDE, forks | 🟢 Free | Repository mirroring with forks: 🟣 |
| Merge methods and squash; merge checks (pipelines must succeed, threads resolved); merge request pipelines | 🟢 Free | |
| Merged results pipelines, merge trains | 🟣 Premium | |
| Suggestions and reviews | 🟢 Free | "Find reviewers who fulfill approval rules", "Prevent merge when you request changes": 🟣 |
| Optional merge request approvals | 🟢 Free | |
| **Required** approvals, approval rules, approval settings (prevent author approval, remove approvals on new commits, prevent editing rules) | 🟣 Premium | Security approvals in rules: 🟠. **Settings can be set for an instance or top-level group and lock the projects below; rules are project level only** |
| **Protected branches** (project) | 🟢 Free | Target branch rules, group-level protected branches, specific users or groups to push or merge, who can unprotect, and **Require Code Owner approval**: 🟣 |
| Protected tags | 🟢 Free | Preventing tag deletion: 🟣 |
| **Code owners** (`CODEOWNERS`, sections, optional sections, several approvals) | 🟣 Premium | |
| Push rules (all of them) | 🟣 Premium | Global and group rules are a template for new projects only |
| Signed commits: verification (GPG, SSH, X.509) | 🟢 Free | **Enforcing** them with push rules: 🟣 |
| Issue and MR description templates | 🟢 Free | Group-level and instance-level templates: 🟣 |

### Planning

| Feature | Tier | Notes |
| --- | --- | --- |
| Issues, tasks (work items), labels, milestones, issue boards (multiple boards), time tracking, wiki, snippets, Pages, quick actions, to-do list, notifications | 🟢 Free | Task status, weight, iterations; assignee, milestone and iteration board lists, swimlanes, WIP limits: 🟣 |
| Scoped labels, epics, iterations | 🟣 Premium | |

### Registries and releases

| Feature | Tier | Notes |
| --- | --- | --- |
| Container registry, cleanup policies, protected container tags, package registry, dependency proxy, releases, deploy tokens, deploy keys, service accounts | 🟢 Free | Package audit events: 🟣. Release metrics: 🟠 |
| Personal access tokens, SSH keys | 🟢 Free | Disabling access tokens (and for enterprise users): 🟣. **Requiring** an expiry: 🟢. **Limiting token and SSH key lifetime**: 🟠 |
| Project and group access tokens | Not stated | The pages list only the offering (GitLab.com, Self-Managed, Dedicated) |

### CI/CD

| Feature | Tier | Notes |
| --- | --- | --- |
| Pipelines, runners, `.gitlab-ci.yml`, pipeline editor, schedules, caching, artifacts, test reports, code coverage, environments, review apps, deployment freezes | 🟢 Free | `secrets:` (external managers): 🟣. Downloading artifacts with the job token: 🟣. Auto rollback and alerts for environments: 🟠 |
| CI/CD variables (project, group, instance), protected, masked; **minimum role for pipeline variables**; **job token allowlist** and its instance-wide enforcement; runner registration controls | 🟢 Free | **Environment-scoped variables**: 🟣 |
| Components and catalog; parent-child and multi-project pipelines | 🟢 Free | Usage details and using a GitLab.com component on self-managed: 🟣. Fetching artifacts from an upstream pipeline: 🟣 |
| ID tokens (OIDC) | 🟢 Free | |
| **Protected environments**, **deployment approvals**, external secrets (Vault and others) | 🟣 Premium | |
| Code quality | 🟢 Free | Report in the pipeline view: 🟣. MR changes view and project view: 🟠 |

### Security scanning

| Feature | Tier | Notes |
| --- | --- | --- |
| **SAST** (basic analyzers), **secret detection**, **container scanning** and **IaC scanning** in pipelines; JSON reports; security configuration page | 🟢 Free | Optimised scanning, duplicate tracking, scanning the registry: 🟠 |
| Findings in the MR, vulnerability report and dashboard, **dependency scanning**, GitLab Advanced SAST, **secret push protection**, DAST, API security testing | 🟠 Ultimate | |
| Security policies: scan execution, merge request approval, pipeline execution, vulnerability management | 🟠 Ultimate | |

The scanners **run in Free**; what GitLab does with the findings (merge request widget, vulnerability report, policies) is **Ultimate**.

### Identity, compliance, audit and reporting

| Feature | Tier | Notes |
| --- | --- | --- |
| Two-factor authentication and its enforcement; Admin Mode; LDAP; OpenID Connect; instance-level SAML (self-managed); service accounts; sign-up, visibility and session settings; dormant-user deactivation | 🟢 Free | |
| Group SAML SSO and SAML group sync (GitLab.com); **SCIM** (group on GitLab.com; **self-managed and Dedicated**); enterprise users; Auditor users; group IP and e-mail-domain restriction; membership lock; prevent forking outside a group; group-level protected branches; restrict project deletion | 🟣 Premium | |
| Custom roles; administrator approval for role promotions; credentials inventory | 🟠 Ultimate | Minimal Access role: 🟣. A Security Manager role exists as a **beta**, disabled by default |
| Audit events: group, project and instance; audit events API; audit event types | 🟣 Premium | The audit events overview page is Free. Retention is indefinite |
| Audit event streaming (group and instance) | 🟠 Ultimate | |
| Compliance frameworks; compliance center; framework and projects reports | 🟣 Premium | **Creating a framework from a template** (SOC 2, ISO 27001 and others) and **requirements**, and the **violations** and **status** reports: 🟠 |
| Compliance pipelines | 🟠 Ultimate | **Deprecated** in 17.3, planned removal in 20.0; replaced by pipeline execution policies |
| Group members export (CSV); contribution analytics; merge request analytics | 🟣 Premium | |
| DORA metrics; runner fleet dashboard (beta) | 🟠 Ultimate | |
| Value stream analytics; usage trends (administrators) | 🟢 Free | Aggregation in value stream analytics needs Premium or Ultimate |

Not covered: GitLab Duo (AI) features, which are licensed separately, CI/CD steps, and the arm64 variants.

## Appendix D: Pipeline review checklist

Use this when you inherit a pipeline, when a supplier deploys applications through your GitLab, or when you review a change to `.gitlab-ci.yml`. You do not need to write the pipeline; you need to know what it can touch and what would stop it from touching the wrong thing. Work top to bottom. Items marked 🟣 or 🟠 need that tier; on Free, agree the control by hand.

| Area | Check | Where to look |
| --- | --- | --- |
| **1 Who can change what runs** | The default branch is protected; nobody pushes directly | Settings > Repository > Branch rules |
| | Changes to `.gitlab-ci.yml` need a reviewer: code owners and approval rules 🟣 | `.gitlab/CODEOWNERS`, Settings > Merge requests |
| | Includes are not pulled from a place the supplier can change silently (`include:remote`) and are pinned to a tag or SHA | `include:` and the part after `@` |
| | Nobody has more than Developer unless needed; no stale accounts | Manage > Members |
| **2 Secrets** | No credentials in the repository, pipeline file or images | Repo search; secret detection |
| | Production secrets are `Protected`; variables are `Masked` or `Masked and hidden`; key material is a `File` variable | Settings > CI/CD > Variables |
| | Who may start pipelines with variables is limited; variables are scoped to environments 🟣 | Variables list |
| | Jobs do not print secrets (`set -x`, `env`, `docker login -p`); short-lived ID tokens where possible | Scripts and recent logs; `id_tokens:` |
| **3 Runners** | Production jobs run on a runner only protected refs can use; privileged runners are known and limited to Docker-in-Docker jobs | Settings > CI/CD > Runners; ask the owner |
| | The runner is not shared between trusted and untrusted projects; tags are meaningful | Runner scope; job `tags:` |
| **4 What the pipeline does** | Images from a known registry, pinned (tag, ideally digest); no `curl ... \| sh` | `:latest`, unknown namespaces |
| | TLS and SSH verification on | `curl -k`, `StrictHostKeyChecking=no` |
| | Failures are not hidden; quality and security jobs run on merge requests | `allow_failure: true` on tests or scans, `\|\| true`, `rules` |
| | Artifacts hold no secrets and do not live forever; the job token allowlist is narrow | `artifacts:paths`, `expire_in`; Job token permissions |
| **5 Deployment** | Production deploy is a separate job with `environment:` and a manual gate or approval; only named people deploy 🟣 | `when: manual`, Protected environments |
| | Deploys are serialized (`resource_group`); the deployed version is traceable to a commit; there is a rehearsed way back | Operate > Environments; runbook |
| | The deploy credential on the host can do only what deployment needs (the `docker` group is root on that host) | The account on the Docker host |
| **6 Security checks** | Scanners are included and not disabled (`SAST_DISABLED`...); something can say no: a gate job, or a policy 🟠 | `include:`, `variables:`; Secure > Policies |
| **7 Evidence to keep** | Screenshots or exports of branch, environment and variable settings; audit events for the period 🟣; the pipeline file at the reviewed commit; the list of runners; date, reviewer, accepted risks | |

Rate each area **ok**, **ok with follow-ups**, or **not acceptable**. Anything "not acceptable" in secrets or deployment blocks production deployments until fixed. Practice on [`examples/ci/step9-review-this-pipeline.yml`](examples/ci/step9-review-this-pipeline.yml).

---

## Thank you! & Questions?

That's all, thank you for your attention.

Questions?

Let's go for a beer 🍻. Not today, what about [**any other day**](https://cal.com/vojtechmares/beer?overlayCalendar=true)?

## Vojtěch Mareš

- email: [vojtech@mares.cz](mailto:vojtech@mares.cz)
- web: [mares.cz](https://www.mares.cz)
- x (twitter): [@vojtechmares_](https://x.com/vojtechmares_)
- linkedin: [/in/vojtech-mares](https://www.linkedin.com/in/vojtech-mares/)

Did you like the course? Tweet a recommendation on X (Twitter) and tag me (@vojtechmares_) and/or add me on Linked In and I will send you a request for recommendation. Thanks!
