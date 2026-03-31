---
name: validate-example
description: Example skill demonstrating Zod input validation patterns
compatibility: opencode
when_to_use: As a reference for implementing input validation in skills
allowed-tools: ["Read", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Demonstrate proper Zod input validation patterns for opencode skills. Use this as a reference when creating skills that require structured inputs.

## When to use

- Reference for creating validated skills
- Template for new skills
- Testing validation patterns
- Example of best practices

## Rules

- Always validate inputs before processing
- Use descriptive error messages
- Provide sensible defaults
- Document all expected inputs
- Fail fast on validation errors

### Input Validation Schema

This skill expects inputs in this format:

```typescript
{
  operation: "read" | "write" | "analyze",
  target: {
    path: string,           // File or directory path
    type: "file" | "dir"    // Target type
  },
  options?: {
    recursive?: boolean,     // For directory operations
    backup?: boolean,        // Create backup before write
    dryRun?: boolean         // Preview changes without applying
  }
}
```

### Objective Criteria (Yes/No)

- [ ] Validated input against Zod schema
- [ ] Provided clear error messages on failure
- [ ] Used default values where appropriate
- [ ] Documented all input fields
- [ ] Implemented type-safe processing

## Expected Input

JSON object with:
- `operation`: Type of operation (read/write/analyze)
- `target`: Object with `path` and `type`
- `options`: Optional configuration

## Expected Output

- Success: Processed result with confirmation
- Failure: Validation error details

## Zod Validation Implementation

```typescript
import { z } from 'zod'

// Define the schema
const InputSchema = z.object({
  operation: z.enum(['read', 'write', 'analyze'])
    .describe('Type of operation to perform'),
  
  target: z.object({
    path: z.string().min(1)
      .describe('File or directory path'),
    type: z.enum(['file', 'dir'])
      .describe('Target type')
  }),
  
  options: z.object({
    recursive: z.boolean().default(false)
      .describe('Process directories recursively'),
    backup: z.boolean().default(true)
      .describe('Create backup before writes'),
    dryRun: z.boolean().default(false)
      .describe('Preview without applying')
  }).optional().default({})
})

// Type inference
type ValidatedInput = z.infer<typeof InputSchema>

// Validate function
function validateInput(input: unknown): { 
  success: true; data: ValidatedInput } | { 
  success: false; errors: string[] 
} {
  const result = InputSchema.safeParse(input)
  
  if (result.success) {
    return { success: true, data: result.data }
  }
  
  return {
    success: false,
    errors: result.error.errors.map(err => 
      `${err.path.join('.')}: ${err.message}`
    )
  }
}

// Example usage
const rawInput = {
  operation: 'read',
  target: {
    path: './src/components',
    type: 'dir'
  }
}

const validation = validateInput(rawInput)

if (!validation.success) {
  console.error('Validation failed:', validation.errors.join(', '))
  // Output: Validation failed: operation: Invalid enum value
  process.exit(1)
}

// Now validation.data is fully typed
const { operation, target, options } = validation.data
// operation: 'read' | 'write' | 'analyze'
// target: { path: string, type: 'file' | 'dir' }
// options: { recursive: boolean, backup: boolean, dryRun: boolean }
```

## Advanced Validation Patterns

### 1. Conditional Validation

```typescript
const ConditionalSchema = z.object({
  type: z.enum(['file', 'url']),
  path: z.string().optional(),
  url: z.string().url().optional()
}).refine(data => {
  if (data.type === 'file') return !!data.path
  if (data.type === 'url') return !!data.url
  return true
}, {
  message: 'path is required for file type, url for url type'
})
```

### 2. Array Validation

```typescript
const FilesSchema = z.object({
  files: z.array(z.string().min(1)).min(1)
    .describe('At least one file path required'),
  
  patterns: z.array(z.string()).optional()
    .describe('Glob patterns to match')
})
```

### 3. Number Constraints

```typescript
const PaginationSchema = z.object({
  page: z.number().int().min(1).default(1),
  limit: z.number().int().min(1).max(100).default(10),
  offset: z.number().int().min(0).optional()
})
```

### 4. String Patterns

```typescript
const GitRefSchema = z.object({
  branch: z.string()
    .regex(/^[a-zA-Z0-9_-]+$/, 'Invalid branch name')
    .optional(),
  
  commit: z.string()
    .regex(/^[a-f0-9]{7,40}$/, 'Invalid commit hash')
    .optional()
}).refine(data => data.branch || data.commit, {
  message: 'Either branch or commit required'
})
```

### 5. Coercion

```typescript
const CoercedSchema = z.object({
  // Accepts "true", "false", true, false
  enabled: z.coerce.boolean().default(true),
  
  // Accepts "42", 42
  count: z.coerce.number().int().positive()
})
```

## Error Handling Best Practices

```typescript
function handleValidation(input: unknown): ValidatedInput | never {
  const result = InputSchema.safeParse(input)
  
  if (!result.success) {
    const formatted = result.error.errors.map(err => {
      const path = err.path.join('.') || 'input'
      return `• ${path}: ${err.message}`
    }).join('\n')
    
    throw new Error(`Validation failed:\n${formatted}`)
  }
  
  return result.data
}

// Usage with try-catch
try {
  const valid = handleValidation(userInput)
  processValidInput(valid)
} catch (error) {
  console.error(error.message)
  // Show user-friendly error
}
```

## Integration with Skills

### In SKILL.md

Add to frontmatter:
```yaml
input_validation: |
  Schema: InputSchema
  Required: operation ("read"|"write"|"analyze"), target (object)
  Optional: options (object with recursive, backup, dryRun)
  
input_example: |
  {
    "operation": "analyze",
    "target": {
      "path": "./src",
      "type": "dir"
    },
    "options": {
      "recursive": true,
      "dryRun": true
    }
  }
```

### Validation Step

Include in skill execution:
```
Step 1: Validate Input
- Parse raw input as JSON if string
- Validate against Zod schema
- If invalid: return error with details
- If valid: proceed with validated data
```

## Complete Example

See `_utils/zod-validator.md` for comprehensive schema library.

This example shows:
- ✅ Type-safe validation
- ✅ Clear error messages
- ✅ Default values
- ✅ Conditional logic
- ✅ Best practices

Use this pattern for all skills that accept structured inputs.
