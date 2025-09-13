export interface Todo {
  id: number;
  title: string;
  description: string;
  completed: boolean;
  completedAt: string | null;
  createdAt: string;
  updatedAt: string;
  plantId: number;
}

export interface TodoCreateRequest {
  title: string;
  description: string;
  plantId?: number;
}

export interface TodoUpdateRequest {
  title: string;
  description: string;
}