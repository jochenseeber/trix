# QED standard qqlique functions

## Helper functions

### Match expressions with text

    @text = 'Easy peasy!'

The expression `@text` matches the following text:

    Easy peasy!

### Match variables with text

    @text = 'Easy peasy!'

The variable `@text` matches the following text:

    Easy peasy!

### Match enumerable expressions with text

    @text = ['Easy peasy!']

The expression `@text` matches the following text:

    Easy peasy!

### Match enumerable variables with text

    @text = ['Easy peasy!']

The variable `@text` matches the following text:

    Easy peasy!

### Clean text

Removes leading white and trailing space and normalizes white space.

    clean_text("  Easy  peasy!  ").assert == 'Easy peasy!'

Removes blank lines.

    clean_text("  \n  Easy  \n\npeasy!\n   \n\n\n").assert == "Easy\npeasy!"

Replaces tabs with spaces.

    clean_text("\tEasy\tpeasy!\t").assert == "Easy peasy!"
