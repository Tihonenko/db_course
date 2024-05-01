import * as oracledb from "oracledb";

class Database {
	private static connection: oracledb.Connection | null = null;

	static async getConnection(): Promise<oracledb.Connection> {
		if (!this.connection) {
			this.connection = await oracledb.getConnection({
				user: "ADMIN_LIB_PDB",
				password: "1234",
				connectionString: "localhost:1521/pdb_lib",
			});
		}
		return this.connection;
	}
}

export default Database;
