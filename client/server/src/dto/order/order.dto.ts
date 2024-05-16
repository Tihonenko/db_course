export enum orderStatus {
	start = "Выдан",
	end = "Завершен",
	process = "В процессе",
	cancel = "Отменен",
}

export interface IOrder {
	userId: string;
	bookId: string;
	days?: number;
	hours?: number;
	minutes?: number;
	status: string;
}
