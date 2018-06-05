### Creating a brand new Image-* repo

To use the files in this repo as the base for your new docker image project, please follow these steps:

- Create a brand new 'image-your-repo' repo in github, making sure the checkbox for `Initialize this repository with a README` is checked. This will put an empty README file in your master branch as its first commit. This will help to create the full file diff when making your first PR of the feature branch against the master branch.
- While on the github page for your new repo, navigate to <strong>settings -> Collaborators &amp; teams</strong>. Under the Teams section configure it as follows: <br /> ![collaborator settings](https://github.com/pearsontechnology/image-template/blob/master/images/collaborator_settings.png)
- Clone your newly created repo onto your local machine `git clone git@github.com:pearsontechnology/image-your-repo.git`
- `cd image-your-repo && git clone git@github.com:pearsontechnology/image-template.git`
- `mv image-template/* ./ `
- `mv image-template/.gitignore ./ && mv image-template/.lgtm ./ && mv image-template/.travis.yml ./ `
- At this point the only thing remaining in the image-template folder is likely to be the `.git/` folder. If so, you can now delete the image-template folder. If there are more files remaining that you need please copy them over before the next step.
- `rm -rf image-template`
- `rm travis/repos.txt && rm -rf images`
- Create your feature branch `git checkout -b bite-xxyy`

Your project is now ready for you to work on.
