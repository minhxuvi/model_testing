# Requirements Specification

## Overview

A python function that takes a prompt as input and uses the ollama library to generate text. The function should:

- Use the llama3.1:8b model
- Send the prompt as a user message
- Set temperature to 0 for deterministic output
- Set seed to 42 for reproducibility
- Return only the message content from the response

## Git config

- ignore sensitive files or directories
- ignore build artifacts
- ignore dependency directories
- ignore OS-specific files

## Test plan

- test.sh to run tests
