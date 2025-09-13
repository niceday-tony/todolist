import React from 'react';
import styles from './TodoItem.module.css';
import type { Todo } from '../../../types/Todo';

interface TodoItemProps {
  todo: Todo;
  onComplete: (id: number) => void;
  onDelete: (id: number) => void;
}

export const TodoItem: React.FC<TodoItemProps> = ({
  todo,
  onComplete,
  onDelete,
}) => {
  const handleComplete = () => {
    onComplete(todo.id);
  };

  const handleDelete = () => {
    if (window.confirm('정말로 이 할일을 삭제하시겠습니까?')) {
      onDelete(todo.id);
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  return (
    <div className={`${styles.todoItem} ${todo.completed ? styles.completed : ''}`}>
      <div className={styles.checkboxContainer}>
        <input
          type="checkbox"
          checked={todo.completed}
          onChange={handleComplete}
          className={styles.checkbox}
        />
      </div>

      <div className={styles.content}>
        <h3 className={styles.title}>{todo.title}</h3>
        {todo.description && (
          <p className={styles.description}>{todo.description}</p>
        )}
        <div className={styles.metadata}>
          <span className={styles.date}>
            생성: {formatDate(todo.createdAt)}
          </span>
          {todo.completed && todo.completedAt && (
            <span className={styles.completedDate}>
              완료: {formatDate(todo.completedAt)}
            </span>
          )}
        </div>
      </div>

      <div className={styles.actions}>
        <button
          onClick={handleComplete}
          className={`${styles.actionButton} ${styles.completeButton}`}
          title={todo.completed ? '미완료로 변경' : '완료로 변경'}
        >
          {todo.completed ? '↶' : '✓'}
        </button>
        <button
          onClick={handleDelete}
          className={`${styles.actionButton} ${styles.deleteButton}`}
          title="삭제"
        >
          🗑️
        </button>
      </div>
    </div>
  );
};