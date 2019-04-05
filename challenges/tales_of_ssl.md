# Tales of SSL

`25 points`

Your task is to programmatically generate a [self-signed] certificate according to the data you receive from the challenge endpoint.

Things you may be asked to include in the certificate:

*   a specific country as the organization's country
*   a specific certificate serial number
*   the domains the certificate should be valid for
*   specific valid from & to dates

Encode the certificate in DER format with base64 and `POST` it to the solution endpoint.

##### Getting the problem set

[`GET /challenges/**tales_of_ssl**/problem**?access_token=b6c1145b5468318c**`](/challenges/tales_of_ssl/problem?access_token=b6c1145b5468318c)

Problem JSON structure:

*   `private_key`: the key we want you to use for the certificate
*   `required_data`
    *   `domain`: the domain the certificate should be valid for
    *   `serial_number`: an extravagant serial number
    *   `country`: let's pretend we're from over there

##### Submitting a solution

`POST /challenges/**tales_of_ssl**/solve**?access_token=b6c1145b5468318c**`

Your solution should be a JSON with the following keys inside it:

*   `certificate`: the requested certificate in base64 encoded DER format

##### Background

Why all this? Well, sooner or later in your life, you'll run into issues with SSL. It's amazing how little thought we give to what's inside the magical blob of bytes, often treating certificates as completely opaque files that we just send, copy and move between servers without much understanding of what's inside - what's PEM? Is this a PEM? Wait, is it a CRT? With ASN? And where's my CSR? So here's an excuse for a little dive into the basics of what's inside a certificate. Depending on the approach you take, you'll probably learn a bit about the magnificent `openssl` library. You got that going on for you, which is nice.