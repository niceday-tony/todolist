import { useState, useEffect, useCallback } from 'react';
import { todoService } from '../services/todoService';
import type { Todo, TodoCreateRequest, TodoUpdateRequest } from '../types/Todo';

export const useTodos = (plantId: number = 1) => {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  const fetchTodos = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const fetchedTodos = await todoService.getAllTodos(plantId);
      setTodos(fetchedTodos);
    } catch (err) {
      console.error('Failed to fetch todos:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch todos');
    } finally {
      setLoading(false);
    }
  }, [plantId]);

  const createTodo = async (todoData: TodoCreateRequest): Promise<Todo> => {
    try {
      setError(null);
      const newTodo = await todoService.createTodo({
        ...todoData,
        plantId,
      });
      setTodos(prev => [newTodo, ...prev]);
      return newTodo;
    } catch (err) {
      console.error('Failed to create todo:', err);
      const errorMessage = err instanceof Error ? err.message : 'Failed to create todo';
      setError(errorMessage);
      throw new Error(errorMessage);
    }
  };

  const updateTodo = async (id: number, todoData: TodoUpdateRequest): Promise<Todo> => {
    try {
      setError(null);
      const updatedTodo = await todoService.updateTodo(id, todoData);
      setTodos(prev =>
        prev.map(todo => (todo.id === id ? updatedTodo : todo))
      );
      return updatedTodo;
    } catch (err) {
      console.error('Failed to update todo:', err);
      const errorMessage = err instanceof Error ? err.message : 'Failed to update todo';
      setError(errorMessage);
      throw new Error(errorMessage);
    }
  };

  const deleteTodo = async (id: number): Promise<void> => {
    try {
      setError(null);
      await todoService.deleteTodo(id);
      setTodos(prev => prev.filter(todo => todo.id !== id));
    } catch (err) {
      console.error('Failed to delete todo:', err);
      const errorMessage = err instanceof Error ? err.message : 'Failed to delete todo';
      setError(errorMessage);
      throw new Error(errorMessage);
    }
  };

  const completeTodo = async (id: number): Promise<Todo> => {
    try {
      setError(null);
      const updatedTodo = await todoService.completeTodo(id);
      setTodos(prev =>
        prev.map(todo => (todo.id === id ? updatedTodo : todo))
      );
      return updatedTodo;
    } catch (err) {
      console.error('Failed to complete todo:', err);
      const errorMessage = err instanceof Error ? err.message : 'Failed to complete todo';
      setError(errorMessage);
      throw new Error(errorMessage);
    }
  };

  useEffect(() => {
    fetchTodos();
  }, [fetchTodos]);

  return {
    todos,
    loading,
    error,
    createTodo,
    updateTodo,
    deleteTodo,
    completeTodo,
    refetch: fetchTodos,
  };
};