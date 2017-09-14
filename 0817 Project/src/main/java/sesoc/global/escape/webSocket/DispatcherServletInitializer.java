package sesoc.global.escape.webSocket;

import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class DispatcherServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return null;
	}//getRootConfigClasses
	
	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[]{WebConfig.class};
	}//getServletConfigClasses
	
	@Override
	protected String[] getServletMappings() {
		return new String[]{"/"};
	}//getServletMappings
	
	@Override
	protected void customizeRegistration(Dynamic registration) {
		registration.setInitParameter("dispatchOptionRequest", "true");
	}//customizeRegistration
	
}//DispatcherServletInitializer
