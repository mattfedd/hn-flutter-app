# hacker_news

A new Flutter project.

API
- https://hn.algolia.com/api
- https://github.com/HackerNews/API

Story list modes
- `/topstories`
- `/newstories`
- `/beststories`
- `/askstories`
- `/jobstories`
- `/showstories`

Things to do 
- [x] get initial story IDs to make a list 
- [ ] find a way to get each story title, probably async for each one? 
- [ ] display the list of stories in a list
- [ ] some sort of fetch operation to get more stories as user scrolls further
- [ ] some sort of caching to get a bunch of stories up front and not require internet for every refresh
- [ ] some sort of styling on the list items
- [ ] switch between story list modes above (top, new, best, etc)
- [ ] clicking a story title opens the link in a browser
- [ ] make a new window for comment viewing
- [ ] use some sort of BFS with depth limits to get comments in a nice way
- [ ] cache fetched comment tree structure somehow
- [ ] clicking something on the story title in the list, opens comment view window
- [ ] ability to favorite a story or comment
- [ ] clicking something on a comment opens a user's profile 
- [ ] search menu with angolia api, results are similar to story list view


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
