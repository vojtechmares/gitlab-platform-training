# Git practice scenarios

Small scripts that build a repository in a particular state, so you can practise fixing it.
Used in Chapters 1 and 2 of the GitLab Platform training. Everything here is plain Git: no GitLab licence is needed.

## Use

Run a script with `bash`, giving it the folder to create. Running it again **rebuilds the scenario from scratch**.

```bash
bash git-exercises/history.sh practice-history
cd practice-history
git log --oneline --graph --all
```

| Script | Situation | Practise |
| ------ | --------- | -------- |
| `history.sh` | A repository with history worth reading | `log`, `show`, `diff`, `blame`, `log -S`, tags |
| `conflict.sh` | Two branches changed the same line | `merge`, conflict markers, `merge --abort` |
| `wrong-branch.sh` | Two commits were made on `main` by mistake | `branch`, `reset` |
| `lost-work.sh` | A hard reset and a deleted branch ate commits | `reflog`, `branch`, `reset` |
| `messy-history.sh` | Seven messy commits before a review | `rebase -i` |
| `bisect.sh` | A bug crept in somewhere in 16 commits | `bisect`, `revert` |

## Notes

- **Windows:** use **Git Bash**. The scripts do not work in PowerShell or `cmd`.
- Each scenario sets a few options in its own repository (`merge.ff`, `pull.rebase`, `core.editor`) so it behaves the same whatever
  your global Git configuration says. That is intentional; `git config --list --show-origin` shows where each setting comes from.
- Running a script **deletes and rebuilds the folder you name** (that is how you reset a scenario). To protect your own work, a script
  refuses to touch a folder that is not an earlier practice scenario: choose a new name if you see that message.
