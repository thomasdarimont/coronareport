package quarano.user;

import static org.assertj.core.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import lombok.RequiredArgsConstructor;
import quarano.QuaranoWebIntegrationTest;
import quarano.util.TokenResponse;

import java.util.Map;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;

@QuaranoWebIntegrationTest
@RequiredArgsConstructor
class UserControllerIntegrationTests {

	private final MockMvc mvc;
	private final ObjectMapper mapper;

	@Test
	void testLoginWithValidCredentials() throws Exception {

		// Accounts and password created by dummy data input beans given
		var username = "DemoAccount";
		var password = "DemoPassword";

		// when
		String resultLogin = mvc.perform(post("/login") //
				.header("Origin", "*") //
				.contentType(MediaType.APPLICATION_JSON) //
				.content(createLoginRequestBody(username, password))) //
				.andExpect(status().isOk()) //
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON)) //
				.andReturn().getResponse().getContentAsString();

		TokenResponse response = mapper.readValue(resultLogin, TokenResponse.class);

		// check if token is valid for authentication
		String resultDtoStr = mvc.perform(get("/api/user/me") //
				.header("Origin", "*") //
				.header("Authorization", "Bearer " + response.getToken()) //
				.contentType(MediaType.APPLICATION_JSON)) //
				.andExpect(status().isOk()) //
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON)) //
				.andReturn().getResponse().getContentAsString();

		DocumentContext document = JsonPath.parse(resultDtoStr);

		assertThat(document.read("$.username", String.class)).isEqualTo("DemoAccount");
		assertThat(document.read("$.firstName", String.class)).isEqualTo("Markus");
		assertThat(document.read("$.lastName", String.class)).isEqualTo("Hanser");
		assertThat(document.read("$.healthDepartment.name", String.class)).isEqualTo("GA Mannheim");
		assertThat(document.read("$.healthDepartment.email", String.class)).isEqualTo("email@gamannheim.de");
		assertThat(document.read("$.healthDepartment.phone", String.class)).isEqualTo("0123456789");
	}

	@Test
	void testLoginWithInvalidCredentials() throws Exception {
		expectLoginRejectedFor("DemoAccount", "My-Wrong-Password");
	}

	@Test
	void loginWithInvalidUsernameIsRejected() throws Exception {
		expectLoginRejectedFor("InvalidUsername", "DemoPassword");
	}

	@Test
	void testThatPreflightRequestsGetNotBlocked() throws Exception {

		// check if token is valid for authentication
		mvc.perform(options("/client/me") //
				.header("Origin", "*") //
				.header(HttpHeaders.ACCESS_CONTROL_REQUEST_METHOD, HttpMethod.OPTIONS)) //
				.andExpect(status().isOk());
	}

	private void expectLoginRejectedFor(String username, String password) throws Exception {

		mvc.perform(post("/login") //
				.header("Origin", "*") //
				.contentType(MediaType.APPLICATION_JSON) //
				.content(createLoginRequestBody(username, password))) //
				.andExpect(status().isUnauthorized());
	}

	private String createLoginRequestBody(String username, String password) throws Exception {
		return mapper.writeValueAsString(Map.of("username", username, "password", password));
	}
}
