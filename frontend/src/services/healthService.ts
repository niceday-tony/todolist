import apiClient from './api';
import type { Todo, TodoCreateRequest, TodoUpdateRequest } from '../types/Todo';

export interface HealthResponse {
  status: string;
  timestamp: string;
  service: string;
  database: string;
  database_url?: string;
  database_error?: string;
}

export interface PingResponse {
  message: string;
  timestamp: string;
}

export const healthService = {
  async checkHealth(): Promise<HealthResponse> {
    const response = await apiClient.get<HealthResponse>('/health');
    return response.data;
  },

  async ping(): Promise<PingResponse> {
    const response = await apiClient.get<PingResponse>('/health/ping');
    return response.data;
  },
};