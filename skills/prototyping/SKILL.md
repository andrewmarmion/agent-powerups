---
name: prototyping
description: "Use for spikes, fast feature drafts, and proof-of-concept work. A variant of brainstorming with testing removed throughout."
---

# Prototyping

## Overview

This is a variant of the brainstorming skill. Follow the brainstorming skill exactly, with these two differences:

## Differences from Brainstorming

**1. Design sections exclude testing and error handling**

When presenting the design, cover: architecture, components, data flow.
Do NOT cover: error handling, testing.

**2. writing-plans is invoked in prototype mode**

When invoking writing-plans, include this explicit override:

> **Prototype mode:** Omit all test steps. Do not write any test code or test commands. Each task follows this structure: implement → manually verify → commit. Manual verification means running the code and confirming the output looks correct (e.g. start the server, call the function, check the output).
