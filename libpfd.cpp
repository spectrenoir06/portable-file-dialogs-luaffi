#include "portable-file-dialogs.h"

#include <cstring>
#include <string>
#include <vector>

char **strlist(const std::vector<std::string>& input)
{
	char **result = new char*[input.size() + 1];
	std::size_t storage_size = 0;
	for (auto const& s: input) {
		storage_size += s.size() + 1;
	}

	try {
		char *storage = new char[storage_size];
		char *p = storage;
		char **q = result;
		for (auto const& s: input) {
			*q++ = std::strcpy(p, s.c_str());
			p += s.size() + 1;
		}
		*q = nullptr; // terminate the list

		return result;
	}
	catch (...) {
		delete[] result;
		throw;
	}
}

void del_strlist(char *const *strings)
{
	// First string is the allocated storage
	delete[] strings[0];
	delete[] strings;
}




extern "C" {
	void notify(const char *title, const char *message, pfd::icon icon) {
		pfd::notify(
			title,
			message,
			icon
		);
	}

	int8_t message(const char *title, const char *text, pfd::choice choice, pfd::icon icon) {
		return ((int8_t)pfd::message(
			title,
			text,
			choice,
			icon
		).result());
	}

	char** open_file(const char *title, const char *initial_path, char **filters, pfd::opt option, uint8_t filter_size) {
		std::vector<std::string> myvector(filters, filters+filter_size);
		std::vector<std::string> strs = pfd::open_file(
			title,
			initial_path,
			myvector,
			option
		).result();

	char** ptr = strlist(strs);

	// del_strlist(v);

	return ptr;
	}
}
