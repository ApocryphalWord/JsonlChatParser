# JsonlChatParser
Simple scripts for parsing exported Kindroid chat logs retrieved from support

## What Is This?
Kindroid has no user-facing chat export tool, but does offer a raw database export for users who email into support, though they will reportedly only do so once every six months.

The file that is returned is said to be a .jsonl file. A .jsonl file is a simple text file containing one row of json on each line - and each row is a message in a conversation.

A .jsonl file can be opened in any text editor, like notepad, but because this file is a non-user-facing database export, it's not the most readable.

This repo contains two simple options for parsing this file for easier reading.

## Local Option (windows)
One simple option is the parse_chat.bat file. Simply drag and drop a .jsonl file onto it, and it will run parse_chat.ps1, which will extract the sender name and message from each jsonl row, and format them as markdown.

## Claude Option
Another option, easier if you don't want to run the file yourself, is to upload the parse_chat.py file and the .jsonl file to an AI assistant like Claude.ai. Claude in particular has a python sandbox available to it, so it can run the file and process the result itself, and give the user the output.

## Further Options
If neither of the above options works - link this repo to any AI assistant - Claude, ChatGPT, or etc, and they can write a solution that WILL work for whatever scenario you're in.

## A Final Note
The author of this repo has never requested an export. I DID test this with snippets provided by other users, and on longer snippets recreated from existing chat logs. If issues arise, let me know - or pass this repo to Claude or another Assistant AI, who will be able to resolve whatever issue.
