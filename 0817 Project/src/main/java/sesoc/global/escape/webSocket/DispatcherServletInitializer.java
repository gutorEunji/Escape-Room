package sesoc.global.escape.webSocket;

import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class DispatcherServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	@Override
	protected Class<?>[] getRootConfigClasses() {
		System.out.println("getRootConfigClasses");
		return null;
	}//getRootConfigClasses
	
	@Override
	protected Class<?>[] getServletConfigClasses() {
		System.out.println("getServletConfigClasses");
		return new Class<?>[]{WebConfig.class};
	}//getServletConfigClasses
	
	@Override
	protected String[] getServletMappings() {
		System.out.println("getServletMappings");
		return new String[]{"/"};
	}//getServletMappings
	
	@Override
	protected void customizeRegistration(Dynamic registration) {
		System.out.println("customizeRegistration");
		registration.setInitParameter("dispatchOptionRequest", "true");
	}//customizeRegistration
	
}//DispatcherServletInitializer
