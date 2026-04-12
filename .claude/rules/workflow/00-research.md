# Research & Reuse (Step 0)

Before any design or implementation, search for existing solutions. Writing net-new code is the last resort.

## Research Order

1. **GitHub code search first**
   - `gh search repos <keywords>` for existing projects
   - `gh search code <pattern>` for implementations of the specific problem
   - Look for open-source projects that solve 80%+ of the problem

2. **Library docs second**
   - Use Context7 MCP or primary vendor docs to confirm API behavior
   - Verify version-specific details before designing around a library

3. **Package registries third**
   - Search npm, PyPI, crates.io, and other registries before writing utility code
   - Prefer battle-tested libraries over hand-rolled solutions

4. **Broader web research last**
   - Only when the first three are insufficient
   - Look for blog posts, tutorials, and reference architectures

## Skeleton Project Pattern

When implementing new functionality:
1. Search for battle-tested skeleton projects or starter templates
2. Evaluate candidates for: security posture, extensibility, maintenance activity
3. Clone/adapt the best match as a foundation
4. Iterate within the proven structure

## Rules

- Prefer adopting or porting a proven approach over writing net-new code
- Document what was searched and why existing solutions were rejected (in the plan's Prior Art section)
- If a library covers the requirement, use it — do not reimplement
- If forking/adapting, credit the source in code comments
