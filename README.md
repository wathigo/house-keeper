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
House Keeper is a [GitHub app](https://developer.github.com/v3/apps/) that merges all the pull requests created by dependabot when the [installation_repositories](https://developer.github.com/v3/activity/events/types/#installation_repositoriesevent) webhook event for `added` action is fired.
All pull requests opened by dependabot are merged when a repository is added to app.

The app also subscribes [pull_request](https://developer.github.com/v3/activity/events/types/#pullrequestevent) webhook event of `opened` action type and merges a pull request opened by dependabot on the allowed repositories.

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

### Built With
* [Ruby](https://www.ruby-lang.org/en/)
* [Sinatra](http://sinatrarb.com/)
* [Octokit](https://github.com/octokit/octokit.rb)

### Contact
* [Simon Wathigo](https://github.com/wathigo) - wathigosimon@gmail.com - [Linkedin](https://www.linkedin.com/in/simon-wathigo-445370183/) - [Portfolio](https://simon-wathigo.netlify.com/)
