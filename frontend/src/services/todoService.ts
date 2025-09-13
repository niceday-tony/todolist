import apiClient from './api';
import type { Todo, TodoCreateRequest, TodoUpdateRequest } from '../types/Todo';

export const todoService = {
  async getAllTodos(plantId?: number): Promise<Todo[]> {
    const params = plantId ? { plantId } : {};
    const response = await apiClient.get<Todo[]>('/todos', { params });
    return response.data;
  },

  async getTodoById(id: number): Promise<Todo> {
    const response = await apiClient.get<Todo>(`/todos/${id}`);
    return response.data;
  },

  async createTodo(todo: TodoCreateRequest): Promise<Todo> {
    const response = await apiClient.post<Todo>('/todos', {
      ...todo,
      plantId: todo.plantId || 1, // Default to plant 1
    });
    return response.data;
  },

  async updateTodo(id: number, todo: TodoUpdateRequest): Promise<Todo> {
    const response = await apiClient.put<Todo>(`/todos/${id}`, todo);
    return response.data;
  },

  async deleteTodo(id: number): Promise<void> {
    await apiClient.delete(`/todos/${id}`);
  },

  async completeTodo(id: number): Promise<Todo> {
    const response = await apiClient.patch<Todo>(`/todos/${id}/complete`);
    return response.data;
  },
};