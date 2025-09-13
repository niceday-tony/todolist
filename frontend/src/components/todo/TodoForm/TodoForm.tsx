import React, { useState } from 'react';
import styles from './TodoForm.module.css';
import type { TodoCreateRequest } from '../../../types/Todo';

interface TodoFormProps {
  onSubmit: (todo: TodoCreateRequest) => Promise<void>;
  loading?: boolean;
}

export const TodoForm: React.FC<TodoFormProps> = ({ onSubmit, loading = false }) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!title.trim()) return;

    setIsSubmitting(true);
    try {
      await onSubmit({
        title: title.trim(),
        description: description.trim(),
        plantId: 1, // Default plant
      });
      // Reset form on success
      setTitle('');
      setDescription('');
    } catch (error) {
      console.error('Failed to create todo:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className={styles.todoForm}>
      <div className={styles.formGroup}>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="할일을 입력하세요..."
          className={styles.titleInput}
          disabled={loading || isSubmitting}
          maxLength={255}
          required
        />
      </div>

      <div className={styles.formGroup}>
        <textarea
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          placeholder="상세 설명 (선택사항)"
          className={styles.descriptionInput}
          disabled={loading || isSubmitting}
          maxLength={1000}
          rows={3}
        />
      </div>

      <button
        type="submit"
        className={styles.submitButton}
        disabled={!title.trim() || loading || isSubmitting}
      >
        {isSubmitting ? '추가 중...' : '할일 추가'}
      </button>
    </form>
  );
};