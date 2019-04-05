# Mini miner

`15 points`

With the Bitcoin thing going strong, I figured it would be interesting to do some simplified mining.

Connect to the problem endpoint. You'll receive a JSON with two attributes. One is `block`, which is in essence an object with a `nonce` value (initially empty) and a `data` key which contains some arbitrary data. The other attribute is `difficulty` - we'll get back to it in a moment.

Your goal is find a `nonce` value that will cause the SHA256 hash of the `block` object to begin with `difficulty` zero bits. E.g. a difficulty of `14` means that the SHA256 digest needs to start with at least 14 zero bits.

The hash should be calculated from a JSON-serialized `block` value _without any whitespace_. The keys needs to be in alphabetical order.

Let's illustrate this on a really simple case. For a `block` with an empty `data` array and a given difficulty of `8` (so the first 8 bits of the SHA256 hash need to be all `0`), a `nonce` value of `45` is one perfectly valid solution:

`SHA256('{"data":[],"nonce":45}') -> 00d696db4...cfb19ec2e0141`

Keep in mind, `difficulty` is the number of `0` **bits**, not bytes.

##### Getting the problem set

[`GET /challenges/**mini_miner**/problem**?access_token=b6c1145b5468318c**`](/challenges/mini_miner/problem?access_token=b6c1145b5468318c)

Problem JSON will be in the following format:

*   `difficulty`: how many bits (high order) need to be 0 in the SHA256 hash
*   `block`:
    *   `nonce`: the nonce you will need to find so that the hash meets the criteria, `None`
    *   `data`: some dummy data that makes up the block

##### Submitting a solution

`POST /challenges/**mini_miner**/solve**?access_token=b6c1145b5468318c**`

You'll only need to submit the `nonce` that causes the JSON-serialized block to yield the proper hash.

Solution JSON structure:

*   `nonce`: the nonce you found

##### Why this challenge?

Because [hashcash](https://en.wikipedia.org/wiki/Hashcash) is an interesting read. Check out the anti-spam usage.