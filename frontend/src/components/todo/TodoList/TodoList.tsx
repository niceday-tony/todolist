import React from 'react';
import { TodoItem } from '../TodoItem/TodoItem';
import { TodoForm } from '../TodoForm/TodoForm';
import { useTodos } from '../../../hooks/useTodos';
import styles from './TodoList.module.css';
import type { TodoCreateRequest } from '../../../types/Todo';

export const TodoList: React.FC = () => {
  const {
    todos,
    loading,
    error,
    createTodo,
    completeTodo,
    deleteTodo,
  } = useTodos(1); // Default plant ID

  const handleCreateTodo = async (todoData: TodoCreateRequest) => {
    await createTodo(todoData);
  };

  const handleCompleteTodo = async (id: number) => {
    try {
      await completeTodo(id);
    } catch (error) {
      console.error('Failed to complete todo:', error);
    }
  };

  const handleDeleteTodo = async (id: number) => {
    try {
      await deleteTodo(id);
    } catch (error) {
      console.error('Failed to delete todo:', error);
    }
  };

  if (loading && todos.length === 0) {
    return (
      <div className={styles.container}>
        <div className={styles.loading}>할일을 불러오는 중...</div>
      </div>
    );
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1 className={styles.title}>🌱 GrowTogether TodoList</h1>
        <p className={styles.subtitle}>할일을 완료해서 식물을 키워보세요!</p>
      </div>

      <TodoForm onSubmit={handleCreateTodo} loading={loading} />

      {error && (
        <div className={styles.error}>
          ❌ {error}
        </div>
      )}

      <div className={styles.todosContainer}>
        {todos.length === 0 ? (
          <div className={styles.emptyState}>
            <div className={styles.emptyIcon}>📝</div>
            <h3>아직 할일이 없습니다</h3>
            <p>위의 양식을 사용해서 첫 번째 할일을 추가해보세요!</p>
          </div>
        ) : (
          <>
            <div className={styles.stats}>
              <span className={styles.statItem}>
                전체: {todos.length}개
              </span>
              <span className={styles.statItem}>
                완료: {todos.filter(todo => todo.completed).length}개
              </span>
              <span className={styles.statItem}>
                남은 할일: {todos.filter(todo => !todo.completed).length}개
              </span>
            </div>

            <div className={styles.todosList}>
              {todos.map((todo) => (
                <TodoItem
                  key={todo.id}
                  todo={todo}
                  onComplete={handleCompleteTodo}
                  onDelete={handleDeleteTodo}
                />
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
};