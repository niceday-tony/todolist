# Complete Personal Task

## Purpose
Complete an individual task assigned to a team member and update all related tracking systems.

## SEQUENTIAL Task Execution

### 1. Validate Task Completion
- Verify all implementation requirements met
- Confirm all tests passing
- Check code quality standards adherence
- Validate integration points working

### 2. Update Personal Task File
- Set status to "Done"
- Add completion date (current date)
- Record actual time spent
- Update progress notes with final summary
- Mark all completion checklist items [x]
- Add final files created/modified list

### 3. Update Story File (Central Tracking)
- Mark corresponding task checkbox [x] in story file
- Update Dev Agent Record > Completion Notes
- Add files to Dev Agent Record > File List
- Update Change Log with task completion entry

### 4. Archive Strategy Decision
Based on core-config.yaml personalWorkspaces.archiveStrategy:

**preserve** (Default):
- Keep task file in personal folder with "Done" status
- Move to `docs/tasks/{member_name}/completed/` subfolder
- Maintain file for reference and metrics

**minimal**:
- Update status to "Done" and keep in place
- Personal task file remains in `docs/tasks/{member_name}/`

**delete**:
- Update story file tracking
- Delete personal task file after completion
- Keep only central story tracking

### 5. Team Notification (Optional)
If configured, update team dashboard or notification system:
- Slack notification format: "@{member} completed {task_title}"
- Update team velocity metrics
- Check if story is fully complete (all tasks done)

### 6. Integration Check
- If task was marked [Integration], trigger integration validation
- If all story tasks complete, notify SM for story review
- Update any dependent tasks in other team members' folders

## Completion Criteria
- Personal task file status updated
- Story file checkbox marked
- Files properly archived/organized
- Team tracking updated
- Integration points validated (if applicable)