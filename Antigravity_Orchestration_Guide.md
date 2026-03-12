# Orchestrating Antigravity: The Manager Persona

**Copyright © 2026 K Hudson (khudsonjd)**
*This document and the methodology described within are free to be used, modified, and distributed by anyone who wishes to do so.*

---

## Introduction to the Multi-Agent Model
As enterprise projects grow in scale and complexity, a single AI session acting as a sequential "pair programmer" becomes a bottleneck. The key to rapid, asynchronous development is adopting a **Manager Persona**, where you treat Antigravity instances not as a single omnibus assistant, but as discrete, parallel "employees" tackling independent tracks of work concurrently.

This document outlines the workflow and best practices for orchestrating multiple Antigravity sessions across different codebases or repositories.

## Single-Session vs. Multi-Session Context
**The Single-Session Limitation**
A continuous chat session builds a contextual history. From a memory perspective, this is excellent for deep tracking of a complex problem (e.g., debugging mDFFS JSON logic). However, as a session grows, the context window fills with legacy iterations, false starts, and conversational weight. A single session cannot simultaneously monitor a Node.js backend build while writing PowerShell scripts; the contexts will bleed into each other, causing degraded performance and hallucinated tool calls.

**The Multi-Session Solution**
By initializing multiple terminal windows (or VSCode integrated terminals), you can launch isolated Antigravity instances. Each instance has its own sterile context window, isolated `task.md` document, and specific objective. 
- Agent A can analyze a monolithic legacy repository.
- Agent B can draft architectural markdown specifications.
- Agent C can scaffold a modern frontend boilerplate based on Agent B's specifications.

## Best Practices for Prompting New Instances

When spinning up a new parallel session, the AI starts with "amnesia" regarding anything discussed in other sessions. Standard conversational prompts ("Can you help me build this app?") are highly inefficient in a multi-agent orchestration architecture.

You must utilize **Bootstrap Prompts**—highly structured, directive instructions that instantly align the new agent to its expected Persona, Track, and Constraints.

### The 4 Pillars of a Bootstrap Prompt
1. **The Persona/Role**: Explicitly define what the agent is (e.g., Code Analyzer, Technical Writer, Frontend Architect).
2. **The Scope Boundary**: Explicitly define what the agent is *not* allowed to touch. (e.g., "Do not modify the database schema").
3. **The Current State**: Provide a one-sentence summary of what exists now.
4. **The Target Output**: Explicitly define the specific artifact or code state the agent must achieve before halting.

## Copy-Pasteable Bootstrap Prompts

Use the following templates when spinning up new sessions to instantly configure the agent for its targeted role.

### The Code Analyzer (Discovery & Mapping)
```text
Role Focus: You are a Code Analyzer. Your sole objective is backend discovery. 
Boundary: You are NOT to write any new code or modify existing logic.
Current State: I have a monolithic legacy application in `./src/legacy`.
Target Output: Analyze the routing structure and output a single markdown artifact named `legacy_routes_map.md` categorizing all endpoints. Halt and notify me when complete.
```

### The Architectural Writer (Documentation & Planning)
```text
Role Focus: You are a Technical Architect. Your objective is drafting implementation plans.
Boundary: You are NOT to execute any PowerShell scripts or modify application code.
Current State: I am preparing to migrate a classic SharePoint list to a modern framework.
Target Output: Review the current list schema and output a high-level `migration_plan.md` artifact detailing the required data mapping. Wait for my approval before proceeding.
```

### The Scaffold Engineer (Rapid Boilerplating)
```text
Role Focus: You are a Build Engineer. Your objective is precise environment scaffolding.
Boundary: Do not attempt to implement business logic or UI design. Stick strictly to boilerplate setup.
Current State: We are starting a new project requiring a Vite/React application with Tailwind.
Target Output: Execute the terminal commands to scaffold the application in `./frontend-app`. Configure the `vite.config.js` and notify me when the dev server is ready to run.
```

### The UI/UX Implementation (Targeted Design)
```text
Role Focus: You are a UI/UX Frontend Developer. 
Boundary: Do not alter backend API routes or database models. 
Current State: The application scaffold exists at `./frontend-app`.
Target Output: Read `design_spec.md`. Implement the React components for the "Dashboard View" using standard Tailwind utility classes. Notify me to review the visual layout when complete.
```

## The Manager's Loop
As the orchestrator, your job shifts from writing code to reviewing PRs and managing state boundaries:
1. Spin up **Agent A (Analyzer)**.
2. While A runs, spin up **Agent B (Scaffold)**.
3. Review A's output artifact.
4. Feed A's artifact into a newly spun **Agent C (Implementation)**.
5. Terminate Agents as their specific objective completes to keep context windows pristine.
