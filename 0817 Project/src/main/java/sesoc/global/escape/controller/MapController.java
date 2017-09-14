package sesoc.global.escape.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MapController {
	@RequestMapping(value = "/editor", method = RequestMethod.GET)
	public String callEditor(){
		return "editor/Editor";
	}
}
