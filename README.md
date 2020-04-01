<p align="center">
  <a href="#">
    <img width=150 height=80 align="center" src="images/logo.png" alt="Logo">
  </a>

  <h3 align="center">House Keeper</h3>

  <p align="center">
    Ruby Project
    <br />
    <br />
    <a href="https://github.com/wathigo/house-keeper/issues">Report Bug</a>
    ·
    <a href="https://github.com/wathigo/house-keeper/issues">Request Feature</a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
  * [Getting Started](#getting-started)
* [Contact](#Contact)




<!-- ABOUT THE PROJECT -->
## About The Project
House Keeper is a [GitHub app](https://developer.github.com/v3/apps/) that subscribes to the following github [webhooks](https://developer.github.com/webhooks/) events:
1. [installation](https://developer.github.com/v3/activity/events/types/#installationevent). When `installation` event of `created` action type is fired, the app fetches all the pull requests from allowed repository meeting the following conditions.
* Have a `status = 'opened'`
* Created by dependabot user.

2. [installation_repositories](https://developer.github.com/v3/activity/events/types/#installation_repositoriesevent). When `installation_repositories` of `added` action type is fired, the app through all the repos, fetches pull request that meets the conditions above, leaves a friendly comment and merges the branch.

3. [pull_request](https://developer.github.com/v3/activity/events/types/#pullrequestevent). When `pull_request` of `opened` action type is fired, the app leaved a comment and merges the pull request of the creator of the pull request is dependabot.

### Getting Started

Go to

```
https://github.com/apps/mjakazi
```
Click on install app

<img align="center" src="images/install.png" alt="Logo">

Choose the repositories

<img align="center" src="images/repos.png" alt="Logo">

Watch all the repo containing pull requests opened by dependabot. You should see this

<img align="center" src="images/res.png" alt="Logo">

To test the application locally,
Clone the repository
``` 
git clone https://github.com/wathigo/house-keeper.git
```
Navigate to the root directory of the cloned repository
```
cd house-keeper
```
Install dependencies
```
bundle install
```
Run tests
```
bundle exec rspec
```

### Built With
* [Ruby](https://www.ruby-lang.org/en/)
* [Sinatra](http://sinatrarb.com/)
* [Octokit](https://github.com/octokit/octokit.rb)

### Contact
* [Simon Wathigo](https://github.com/wathigo) - wathigosimon@gmail.com - [Linkedin](https://www.linkedin.com/in/simon-wathigo-445370183/) - [Portfolio](https://simon-wathigo.netlify.com/)
