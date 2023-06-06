# My portfolio
This is my bookdown repo that contains all data for my portfolio.
my portfolio is hosted trough github at [kjettil.github.io](kjettil.github.io)


To install all dependencies needed to build the bookdown locally, clone the repo to your environment and run in R:

``` R
install.packages("devtools")
devtools::install(".")
``` 
To build the book:

```R
install.packages("bookdown")
bookdown::render_book(".")
```


All RMD files are from my [portfolio repository](https://github.com/kjettil/portfolio)
