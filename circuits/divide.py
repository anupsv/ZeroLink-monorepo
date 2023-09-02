
# function that divides string into parts of size 2characters, and adding the prefix '0x' to each part.
# then it returns a concatenation of the parts, with ' ,' as a separator.
def divide(string):
    parts = [string[i:i+2] for i in range(0, len(string), 2)]
    for i in range(len(parts)):
        parts[i] = '0x' + parts[i]
    return ', '.join(parts)

print(divide('ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d3021ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344'))