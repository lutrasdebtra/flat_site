# Flat Site 

Flat site was born from the requirement to record transactions between myself and multiple flatmates. While we initially used a Google Drive spreadsheet, we had two use-cases that were not ideally suited for the spreadsheet environment:
- Full receipts (not just totals).
- Notifications when payments were made - so they could be queried while they were fresh in our minds. 
In addition to these cases, we also wanted something that could be expanded to different tasks as desired.

## Site Design 

### Main Page

![Main](https://raw.github.com/lutrasdebtra/flat_site/master/main.png)

The main page is a single, clean tab-centric UI that displays amounts owed to each user, from each other user, as well as totals. From here, users are able to view each others' payments, as well as create new payments, and new receipts. 

### Payments

![Payment_Main](https://raw.github.com/lutrasdebtra/flat_site/master/payments_main.png)

The main payments page shows all payments in ascending date order, with the option to delete if the user owns the payment. 

![Payment_new](https://raw.github.com/lutrasdebtra/flat_site/master/payment_new.png)

Creating payments is done using a simple interface. Where individual itemization is required, see Receipts below. 

### Receipts

![Receipts_new](https://raw.github.com/lutrasdebtra/flat_site/master/shopping_list_new.png)

Receipts are payments where individual items can be assigned to different users. In the example above, Katy doesn't eat bread, or eggs, and this is automatically reflected in the totals. 

![Receipts_show](https://raw.github.com/lutrasdebtra/flat_site/master/shopping_show.png)

When created shopping lists are viewed, they use a similar layout to creation screen. 

### Pushbullet

When a payment or a receipt is created, website checks whether a user has a `push_key` in the database (which can be set in the account settings page). If it finds a key, it will send a notification to all users involved in the payment, by way of their emails. 

## Technical Details

### Getting Started

Once the site has been pulled from Github, the first thing to alter is the `/db/seeds.rb` file. When initially creating the site, the seeds file was used to import a Google Drive dump - and importing the (now dated) data is probably not desired. 

In addition to this, it is ideal to seed your own users. In addition to defining them in the seed file, `/db/schema.rb` must be updated. Users have initials, these initials are used in the `payment` and `shopping_list` databases to tie individual users to payments. For instance Stuart Bradley (myself) has the initials `sb`, and as such is related to the `paysb` fields in the databases.

From here, `rake:schema:load` should be all that is required to get the site running. 

### Gems

The interface was designed using [bootstrap](https://github.com/twbs/bootstrap-sass), with a separate gem for the [datepicker](https://github.com/Nerian/bootstrap-datepicker-rails).

The forms use [nested_form](https://github.com/ryanb/nested_form). This has produced a bug where the add item button for receipts fired twice, but it is annoying enough to port the code. 

Other gems include one to [validate times](https://github.com/adzap/validates_timeliness), as well as a wrapper for the [pushbullet API](https://github.com/meinside/pushbullet-ruby).

## License 

The MIT License (MIT)

Copyright (c) [2015] [Stuart Bradleyy]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.