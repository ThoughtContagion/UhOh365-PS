# UhOh365-PS
PowerShell implementation of the functionality found in [Raikia's UhOh365 tool](https://github.com/Raikia/UhOh365)

Functionally compatible with PowerShell versions 5.1+

Excerpt from UhOh365:

> A script that can see if an email address is valid in Office365. This does not perform any login attempts, is unthrottled, and is incredibly useful for social engineering assessments to find which emails exist and which don't.
> Microsoft does not consider "email enumeration" a vulnerability, so this is taking advantage of a "feature". There are a couple other public Office365 email validation scripts out there, but they all (that I have seen) require at least 1 login attempt per user account. That is detectable and can be found as a light bruteforce attempt (1 "common" password across multiple accounts).
> This script allows for email validation with zero login attempts and only uses Microsoft's built-in Autodiscover API so it is invisible to the person/company who owns the email address. Furthermore, this API call appears to be completely unthrottled and I was able to validate over 2,000 email addresses within 1 minute in my testing.

# Usage
Usage differs slightly from Raikia's tool. Invoke-UhOh365-PS.ps1 has a required parameter of `-enumMethod` with valid options being `Single` or `File`.

Single prompts for a single email address to enumerate

`./Invoke-UhOh365-PS.ps1 -enumMethod Single`

![image](https://user-images.githubusercontent.com/88730003/212167311-27e5ba49-4da9-4c21-b86a-21a0df469304.png)


File will read in the supplied txt file and enumerate each email contained therein. The provided text file should contain one email per line.

`./Invoke-UhOh365-PS.ps1 -enumMethod File`

![image](https://user-images.githubusercontent.com/88730003/212167392-976afa80-6200-4f97-9343-adbdf48d13b1.png)
