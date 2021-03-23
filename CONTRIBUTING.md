# Contributing

We welcome everyone's contributions to this repository, and we thank you for them in advance! Scientific progress is quicker when we all work together and share our workflows.

# Ways You Can Help

Your contributions can take multiple forms:
- you can submit bug reports and feature requests through the github issue tracker,
- you can help improve the documentation in the README.md files with each example,
- you can contribute new examples to this repository by submitting pull requests.

# Join The Conversation

The EIC Users Group has an (active slack channel)[https://eicug.slack.com]. Contact us by email to receive an invitation link. Note that we do not post the link here to cut down on spam in the slack workspace.

# Contributing new examples with pull requests

We prefer that you develop new example workflows in a forked version of this repository. When your example is sufficiently complete, you can then submit a pull request to get the example included in the main repository here.

## Creating a fork:
Click the 'fork' button on the top right of the example_workflows repository. You can now clone this repository:
  git clone git@github.com:USERNAME/example_workflows.git
This will fork all current branches in the eic/example_workflows repository.

## Adding a new remote (if you create a fresh clone of your forked repository):
- Add the upstream repository eic/example_workflows to your list of remotes (you only need to do this once):
  git remote add upstream https://github.com/eic/example_workflows.git

## Renaming an existing remote (if you already had the base repository checked out):
After creating a fork, you will need to add this fork as the primary remote (origin) of your local copy.
- Rename the previous remote (eic/example_workflows):
  git remote rename origin upstream
- Add your forked repository as a new remote:
  git remote add origin git@github.com:USERNAME/example_workflows.git

## Keeping your fork up to date:
- Whenever you want to update, fetch the latest upstream changes:
  git fetch upstream
  Variant: git fetch --all
- ... and merge the upstream branch in your branch, e.g. for the 'main' branch
  git checkout --track origin/main
  git merge upstream/main
Avoid making changes directly on master or main, even in your own repository (for the same reasons).

## Doing your work:
It is easiest to do your work in branches, one per logically separate tasks, and to merge those to eic/example_workflows frequently.
- Create a new branch from the main branch (the base of your branch):
  git checkout --track main
  git branch new-feature-xyz
  git checkout new-feature-xyz
- Now, you can do your work in this branch.
- Periodically, push the changes to your repository:
  git push

## Cleaning up your work:
Before contributing your changes back to eic/example_workflows for others to use, it make sense to clean up some.
- Make sure your branch works with the most up to date code in the upstream base branch:
  git fetch upstream
  git checkout main
  git merge upstream/main
- Rebase your branch to point to the most recent code in the base branch:
  git checkout new-feature-xyz
  git rebase main
The rebase phase is when you may need to resolve some conflicts: when you have modified lines that someone else has modified upstream as well. Ask in Slack if you need help resolving conflicts (in git; we can't help with the neighbors).

## Submitting a pull request:
When you are done with your work in a branch and ready to share it with others, go to your branch page on GitHub and click the 'pull request' button. Write a clear summary and wait for someone to merge it (or request some changes, if necessary). After your branch has been merged, you can go ahead and delete it. When you update your main branch, the changes will be included.
