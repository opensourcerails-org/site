# Operating

In the case I die or get hit by a train, here's my normal procedure:

1. Scour github for repos
2. Find a repo, do a quick cursory scan, use bookmarklet to add it to the site if it passes smell test
3. Go to site, see projects with missing logos, use admin to clean up name and add logo
4. Go through all projects with missing categories and add them
5. When bored, do synopsis


## bookmarklet 

`javascript:(function()%7Bconst gh %3D document.querySelector('meta%5Bname%3D"octolytics-dimension-repository_nwo"%5D').getAttribute('content')%3Bvar win %3D window.open(%60https%3A%2F%2Fopensourcerails.org%2Fadmin%2Fdashboard%2Fbookmarklet%3Fgithub%3D%24%7Bgh%7D%60%2C "myWindow"%2C"status %3D 1%2C height %3D 30%2C width %3D 30%2C resizable %3D 0" )%3BsetTimeout( function() %7Bwin.close()%3B%7D%2C 1000)%7D)()`
