# Assign Tasks to Team Members

## Purpose
Assign or reassign tasks from existing stories to team members based on their skills, availability, and workload balance. This command enables dynamic task assignment management after stories have been created.

## SEQUENTIAL Task Execution

### 1. Load Core Configuration and Team Information

- Load `.bmad-core/core-config.yaml` from the project root
- Extract team member information from `team.members` section:
  - **Backend Team**: @tony (database), @martin (api-design), @minam (java/spring-boot), @sony (fullstack)
  - **Frontend Team**: @preah (ui-ux), @sony (fullstack with react)
  - **Skills Matrix**: Load individual skills for each member
- Load personal workspace configuration: `personalWorkspaces.enabled`, `baseLocation`, `structure`

### 2. Story Selection and Task Discovery

#### 2.1 Present Story Options
- Scan `devStoryLocation` for available story files
- Display numbered list of stories with current status:
  ```
  Available Stories for Task Assignment:
  1. Story 1.1: 프로젝트 구조 설정 (Status: Draft)
  2. Story 1.2: 할 일 관리 API 구현 (Status: InProgress)
  3. Story 1.3: 기본 할 일 UI 구현 (Status: Approved)
  4. Story 1.4: 위로의 순환 핵심 기능 구현 (Status: Draft)
  ```

#### 2.2 Load Selected Story
- User selects story number
- Load story file and extract current tasks from `Tasks / Subtasks` section
- Parse existing task assignments (look for `(Assigned: @member_name)` patterns)
- Display current task assignment status:
  ```
  Current Task Assignments for Story 1.2:
  ✓ [ ] Setup database entities (Assigned: @tony) [Independent]
  ✓ [x] Define API contracts (Assigned: @martin) [Contract] - COMPLETED
  ⚠ [ ] Implement service layer (Assigned: TBD) [Independent] - UNASSIGNED
  ✓ [ ] Create frontend components (Assigned: @preah) [Mock]
  ✓ [ ] Integration testing (Assigned: @sony) [Integration]
  ```

### 3. Assignment Mode Selection

Present assignment mode options:
1. **Re-assign Specific Tasks**: Modify existing task assignments
2. **Auto-balance Workload**: Automatically redistribute tasks based on team capacity
3. **Add New Tasks**: Create and assign new tasks to the story
4. **Bulk Assignment Review**: Review and modify all task assignments at once

### 4. Task Assignment Logic (Based on Selected Mode)

#### 4.1 Re-assign Specific Tasks
- Display unassigned tasks with numbered options
- For each selected task:
  - Show task details and requirements
  - Recommend suitable team members based on:
    - **Task Type**: [Mock] → Frontend, [Contract] → Backend API, [Independent] → Any matching skill, [Integration] → Fullstack
    - **Skills Match**: Database tasks → @tony, API design → @martin, UI/UX → @preah, General backend → @minam, Fullstack → @sony
    - **Current Workload**: Display current task count per member
  - Allow manual selection or accept AI recommendation
  - Update task assignment in story file

#### 4.2 Auto-balance Workload
- Calculate current workload per team member across all active stories
- Redistribute unassigned tasks based on:
  - Skills compatibility matrix
  - Current workload balance (aim for even distribution)
  - Task dependencies and parallel execution opportunities
  - Priority of tasks (based on story status and task type)

#### 4.3 Add New Tasks
- Prompt for new task details:
  - Task description
  - Acceptance criteria reference (if applicable)
  - Task type: [Mock], [Contract], [Independent], [Integration]
  - Dependencies on existing tasks
- Recommend assignment based on task characteristics
- Add task to story file in proper format: `- [ ] Task description (Assigned: @member_name) [Task-Type]`

#### 4.4 Bulk Assignment Review
- Display all tasks in story with current assignments
- Allow modification of each assignment interactively
- Show workload impact and skills match for each proposed change
- Apply all changes atomically

### 5. Personal Task File Management

For each newly assigned or reassigned task:

#### 5.1 Create/Update Personal Task Files
- Check if personal task file already exists: `docs/tasks/{member_name}/{epic}.{story}.{task_id}.{task_title_short}.md`
- If task is being reassigned:
  - Move existing file from old member's directory to new member's directory
  - Update file content with new assignment details
- If task is newly assigned:
  - Use `personal-task-tmpl.yaml` template to create new personal task file
  - Populate with task-specific information from story
  - Include relevant mock data/API contracts for parallel development

#### 5.2 Archive Old Assignments (if applicable)
- For reassigned tasks, handle old personal task files based on `archiveStrategy`:
  - **preserve**: Move to `completed/` subfolder with reassignment note
  - **minimal**: Mark as reassigned and keep reference
  - **delete**: Remove old task file after confirmation

### 6. Story File Updates and Validation

#### 6.1 Update Story File
- Update `Tasks / Subtasks` section with new assignments
- Add entry to `Change Log` with assignment changes:
  ```
  | Date | Version | Description | Author |
  |------|---------|-------------|---------|
  | 2024-09-21 | 1.1 | Reassigned service layer task from TBD to @minam | SM Agent |
  ```
- Update `Personal Task Files` section with new task file links

#### 6.2 Validate Assignment Quality
- Check for skills mismatch warnings
- Verify no team member is overloaded (suggest redistribution if needed)
- Ensure parallel development strategy is maintained:
  - Frontend tasks have adequate mock data
  - Backend tasks define proper contracts
  - Integration tasks are properly sequenced

### 7. Team Notification and Summary

#### 7.1 Generate Assignment Summary
```
📋 Task Assignment Summary for Story 1.2

Changes Made:
✅ @minam assigned to "Implement service layer" (previously unassigned)
🔄 @preah reassigned from "Frontend validation" to @sony (workload balance)

New Personal Task Files Created:
- docs/tasks/minam/1.2.3.implement-service-layer.md
- docs/tasks/sony/1.2.4.frontend-validation.md

Current Team Workload:
- @tony: 3 tasks (Database focus)
- @martin: 2 tasks (API design focus)
- @minam: 4 tasks (Testing + new service task)
- @preah: 2 tasks (UI/UX focus)
- @sony: 3 tasks (Integration focus)

Parallel Development Status: ✅ Maintained
Story Status: Ready for Development
```

#### 7.2 Team Notifications (if enabled)
- If `teamNotifications: true` in config:
  - Generate notification format for each affected team member
  - Suggest Slack notification format: "@{member} - you have new task assignment in Story {epic}.{story}"

### 8. Validation and Completion

#### 8.1 Final Validation
- Verify all tasks in story have assignments
- Check that personal task files exist for all assignments
- Ensure story file syntax is correct
- Validate parallel development strategy is preserved

#### 8.2 Optional Follow-up Actions
- Suggest running story checklist if significant changes were made
- Recommend updating story status if now ready for development
- Offer to assign tasks in other stories for consistent workload balance

## Completion Criteria
- Selected story tasks are properly assigned to team members
- Personal task files created/updated in appropriate member directories
- Story file updated with assignment changes and change log entry
- Team workload remains balanced across skills and capacity
- Parallel development strategy maintained
- Assignment summary provided to user