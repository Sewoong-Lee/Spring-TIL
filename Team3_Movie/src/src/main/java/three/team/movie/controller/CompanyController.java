package three.team.movie.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("company")
public class CompanyController {
	
	@GetMapping("ccvInfo")
	public void ccvInfo() {}
	
}
