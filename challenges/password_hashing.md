# Password hashing

`15 points`

Password hashing has come a long way.

The task is straightforward. You'll be given a password, some salt (watch out, it comes base64 encoded, because in this case salt - for extra high entropy - is basically just `/dev/urandom` bytes), and some algorithms-specific parameters.

Your job is to calculate the required `SHA256`, `HMAC-SHA256`, `PBKDF-SHA256` and finally `scrypt`.

There's a secret step here, though you won't get points for it and the reward is englightenment itself: realize how each step uses the previous one on the way to the final result.

##### Getting the problem set

[`GET /challenges/**password_hashing**/problem**?access_token=b6c1145b5468318c**`](/challenges/password_hashing/problem?access_token=b6c1145b5468318c)

Problem JSON structure is:

*   `password`: the password you'll operate on
*   `salt`: the salt we'll use - also user as a `secret` where necessary; keep in mind it comes base64 encoded - decode for the raw bytes
*   `pbkdf2`:
    *   `hash`: the digest to use
    *   `iterations`: the number of rounds to use
*   `scrypt`:
    *   `N`: the N parameter for scrypt's `KDF`
    *   `p`: the parallelization parameter
    *   `r`: the blocksize parameter
    *   `buflen`: intended output length in octets
    *   `_control`: example scrypt calculated for `password="rosebud"`, `salt="pepper"`, `N=128`, `p=8`, `n=4`

##### Submitting a solution

`POST /challenges/**password_hashing**/solve**?access_token=b6c1145b5468318c**`

Your solution should be a JSON with the following keys:

*   `sha256`: the calculated `SHA256`
*   `hmac`: the calculated `HMAC-SHA256`
*   `pbkdf2`: the calculated `PBKDF2` digest
*   `scrypt`: finally, the calculated `scrypt` value

> Send all values in `hexlified` form, e.g. `md5('foo') -> 7ddd5f60c97d589b0becc3c55d6afd25`.

##### Background

Password hashing really has come a long way. There were times when a salt would be appended to the password, the result treated with MD5 and everything was fine. Times have changed, but some things remain confusing until you take a deeper look.

This challenge proposes a path - first, understand what a SHA256 is. It's a hash in the purest meaning of the word. Even better, it's a _cryptographic_ hash, meaning it has [a few useful properties](https://en.wikipedia.org/wiki/Cryptographic_hash_function).

Then, look into what an `HMAC` is. The inner workings are so simple you can even grasp the idea by looking at the [pseudocode](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code#Implementation).

Once you've got that down, it's time to discover the concept of a [key deriviation function](https://en.wikipedia.org/wiki/PBKDF2). From there on, into the beautiful world of trying to make those algorithms [unfeasible](https://www.tarsnap.com/scrypt.html) to brute force.
