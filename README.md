# Namespaced IDs
[![Build Status](https://travis-ci.org/sagmor/nid.svg?branch=master)](https://travis-ci.org/sagmor/nid)

This is an attempt to model a value compatible with the UUID representation

but with the following attributes:

 * Namespaced: Every NID has a namespace value that allow to easily
 diferenciate one ID from another
 * Sortable: a Time object (or current time) is used on the value to allow NID
 object to be sorted within their namespace

Also NID object can be reprented both in UUID format and on *NID* format.
For example `sample__Vq_DG_RasCrrkg` and `b1a9a995-efff-56af-c31b-f45ab02aeb92`
represent the same randomly generated NID within the `sample` namespace.
They are [freely inspired by Stripe's ID scheme](https://www.quora.com/How-does-Stripe-generate-object-ids/answer/Patrick-Collison).

## Usage

To generate a random NID on the `sample` namespace you just:
```ruby
NID.new(:sample)
# => #<NID sample__Vq_DG_RasCrrkg>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

