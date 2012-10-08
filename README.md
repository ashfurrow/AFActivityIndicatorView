`AFActivityIndicatorView`
=======================

A ground-up, home-made implementation of `UIActivityIndicatorView`.

# How to use

Exactly like `UIActivityIndicatorView`.

[Link](http://stackoverflow.com/questions/6956432/adding-quartzcore-to-xcode-4-for-ios) with `QuartzCore`

    AFActivityIndicatorView *loader = [[AFActivityIndicatorView alloc] initWithFrame:CGRectMake(60, 100, 50, 50)];
    loader.activityIndicatorViewStyle = AFActivityIndicatorViewStyleWhite;
    [loader startAnimating];
    [self.view addSubview:loader];

# Really?

Yes.

# Why?

Because I felt like it. 

I tried to spruce it up a little bit, and in the process I discovered that the current spinner design is actually really good, and shouldn't be meddled with.

# So why publish the code?

Because now you can customize colours, etc. 
