import { useState } from "react";
import "./App.css";

const App = () => {
	const [coverFile, setCoverFile] = useState<File | string | null>(null);
	const [pdfFile, setPdfFile] = useState<File | string | null>(null);
	const [title, setTitle] = useState<string>("");
	const [isbn, setIsbn] = useState<string>("");

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();
		const formData = new FormData();

		if (!coverFile) {
			formData.append("cover", "");
		} else {
			formData.append("cover", coverFile);
		}
		if (!pdfFile) {
			formData.append("pdf", "");
		} else {
			formData.append("pdf", "");
		}

		formData.append("title", title);
		formData.append("isbn", isbn);

		try {
			const response = await fetch(
				"http://localhost:8888/api/book/update/463148483569444D44557667597749414571773567513D3D",
				{
					method: "PATCH",
					body: formData,
				}
			);

			if (!response.ok) {
				throw new Error("Network response was not ok");
			}

			const data = await response.json();
			console.log(data);
		} catch (error) {
			console.error(error);
		}
	};
	return (
		<>
			<form onSubmit={handleSubmit}>
				<div>
					<label htmlFor='title'>Title book:</label>
					<input
						type='text'
						id='title'
						name='title'
						onChange={(e) => setTitle(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='isbn'>ISBN book:</label>
					<input
						type='text'
						id='isbn'
						name='isbn'
						onChange={(e) => setIsbn(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='cover'>Cover Image:</label>
					<input
						type='file'
						id='cover'
						name='cover'
						onChange={(e) => setCoverFile(e.target.files && e.target.files[0])}
					/>
				</div>
				<div>
					<label htmlFor='pdf'>PDF File:</label>
					<input
						type='file'
						id='pdf'
						name='pdf'
						onChange={(e) => setPdfFile(e.target.files && e.target.files[0])}
					/>
				</div>
				<button type='submit'>Upload Files</button>
			</form>
		</>
	);
};

export default App;
