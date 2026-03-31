---
name: zod-validator
description: Zod validation schemas for skill inputs
compatibility: opencode
---

# Zod Validation Helper for Skills

This utility provides Zod schemas for validating skill inputs. Use it to ensure skills receive valid parameters.

## Usage

Add to your skill's frontmatter:
```yaml
---
name: my-skill
description: Does something
allowed-tools: ["Read", "Edit"]
input_schema: |
  {
    "filePath": "string - required",
    "lineCount": "number - optional"
  }
---
```

## Common Validation Schemas

### Basic Schemas

```typescript
// String validation
const StringSchema = z.string()
const NonEmptyStringSchema = z.string().min(1)
const PathSchema = z.string().regex(/^[./][a-zA-Z0-9_/.-]+$/)

// Number validation
const NumberSchema = z.number()
const PositiveIntSchema = z.number().int().positive()
const LineNumberSchema = z.number().int().min(1)

// Boolean validation
const BooleanSchema = z.boolean()
```

### Skill Input Schemas

```typescript
// File-related inputs
const FileInputSchema = z.object({
  filePath: z.string().min(1).describe("Path to the file"),
  offset: z.number().int().min(1).optional().describe("Line number to start from"),
  limit: z.number().int().positive().optional().describe("Max lines to read")
})

// Search-related inputs
const SearchInputSchema = z.object({
  pattern: z.string().min(1).describe("Regex or string pattern to search"),
  path: z.string().optional().describe("Directory to search in"),
  include: z.string().optional().describe("File pattern to include (e.g., *.ts)")
})

// Diff/Change inputs
const DiffInputSchema = z.object({
  files: z.array(z.string()).optional().describe("List of files to analyze"),
  branch: z.string().optional().describe("Git branch to compare"),
  since: z.string().optional().describe("Check changes since (e.g., '1 day ago')")
})

// Task/Feature inputs
const TaskInputSchema = z.object({
  description: z.string().min(10).describe("Detailed task description"),
  priority: z.enum(["low", "medium", "high"]).default("medium"),
  files: z.array(z.string()).optional().describe("Relevant files")
})

// Model routing inputs
const ModelRouteInputSchema = z.object({
  task: z.string().min(10).describe("Task description"),
  taskType: z.enum(["analysis", "implementation", "debugging"]).optional(),
  complexity: z.enum(["low", "medium", "high"]).default("medium")
})
```

### Validation Helpers

```typescript
// Validate with detailed error message
function validateInput<T>(schema: z.ZodSchema<T>, input: unknown): { 
  success: true; data: T } | { 
  success: false; errors: string[] 
} {
  const result = schema.safeParse(input)
  if (result.success) {
    return { success: true, data: result.data }
  }
  return { 
    success: false, 
    errors: result.error.errors.map(e => `${e.path.join('.')}: ${e.message}`)
  }
}

// Assert validation (throws on failure)
function assertValid<T>(schema: z.ZodSchema<T>, input: unknown): T {
  return schema.parse(input)
}

// Check if input matches schema
function isValid<T>(schema: z.ZodSchema<T>, input: unknown): input is T {
  return schema.safeParse(input).success
}
```

## Example: Validating Skill Input

```typescript
// In your skill execution:
const input = {
  filePath: "/path/to/file.ts",
  offset: 10,
  limit: 50
}

const validation = validateInput(FileInputSchema, input)

if (!validation.success) {
  return {
    error: `Invalid input: ${validation.errors.join(', ')}`
  }
}

// Now validation.data is typed and safe to use
const { filePath, offset, limit } = validation.data
```

## Pre-built Skill Input Validators

### For repo_analysis
```typescript
const RepoAnalysisInputSchema = z.object({
  scope: z.enum(["structure", "dependencies", "architecture", "all"]).default("all"),
  depth: z.enum(["shallow", "medium", "deep"]).default("medium"),
  focus: z.array(z.string()).optional().describe("Specific areas to focus on")
})
```

### For feature-implement
```typescript
const FeatureImplementInputSchema = z.object({
  feature: z.string().min(10).describe("Feature description"),
  targetFiles: z.array(z.string()).optional(),
  tests: z.boolean().default(true),
  documentation: z.boolean().default(false)
})
```

### For code_debug
```typescript
const CodeDebugInputSchema = z.object({
  error: z.string().optional().describe("Error message or description"),
  failingFiles: z.array(z.string()).optional(),
  reproduction: z.string().optional().describe("Steps to reproduce"),
  scope: z.enum(["quick", "thorough"]).default("thorough")
})
```

### For audit-code
```typescript
const AuditCodeInputSchema = z.object({
  files: z.array(z.string()).optional(),
  since: z.string().optional(),
  severity: z.array(z.enum(["critical", "high", "medium", "low"])).default(["critical", "high", "medium"]),
  scope: z.enum(["security", "bugs", "performance", "all"]).default("all")
})
```

## Error Message Templates

```typescript
const ValidationErrorMessages = {
  REQUIRED: (field: string) => `${field} is required`,
  INVALID_TYPE: (field: string, expected: string) => `${field} must be a ${expected}`,
  INVALID_FORMAT: (field: string) => `${field} has invalid format`,
  OUT_OF_RANGE: (field: string, min: number, max: number) => 
    `${field} must be between ${min} and ${max}`,
  INVALID_ENUM: (field: string, values: string[]) => 
    `${field} must be one of: ${values.join(', ')}`
}
```

## Best Practices

1. **Always validate at skill entry point** - Catch errors early
2. **Use `.describe()`** - Provides helpful error messages
3. **Provide defaults** - Use `.default()` for optional fields
4. **Be specific** - Tight validation is better than loose
5. **Error messages** - Make them actionable and clear
6. **Coerce types** - Use `.coerce()` when accepting string numbers

## Integration with Skills

Add to your SKILL.md:
```yaml
input_validation: |
  Uses zod-validator schema: TaskInputSchema
  Required: description (string, min 10 chars)
  Optional: priority ("low"|"medium"|"high"), files (string[])
```

Or in execution:
```
Input validation:
- Validate with TaskInputSchema
- On error: return validation errors
- On success: proceed with validated data
```
