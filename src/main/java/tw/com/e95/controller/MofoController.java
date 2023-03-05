package tw.com.e95.controller;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.dom.DOMSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import tw.com.e95.Utils;
import tw.com.e95.entity.Mofo;
import tw.com.e95.entity.Staff;
import tw.com.e95.repository.MofoRepository;
import tw.com.e95.repository.StaffRepository;
import tw.com.e95.service.Services;

/**
 * 攤商分類
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Controller
@RequestMapping("/mofo")
public class MofoController {

	@Autowired
	private MofoRepository mofoRepository;

	@Autowired
	private StaffRepository staffRepository;

	@PersistenceUnit
	private EntityManagerFactory entityManagerFactory;

	@Autowired
	private Services services;

	/**
	 * 列表(攤商分類)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView welcome(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildFooterElement(documentElement);//底部

		/*
		 找出預設(數量最少)的攤商分類
		 */
		Mofo mofo = null;
		EntityManager entityManager = entityManagerFactory.createEntityManager();
		entityManager.getTransaction().begin();
		Connection connection = entityManager.unwrap(java.sql.Connection.class);
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery("SELECT\"mofo\"AS\"id\"FROM\"e95Mall\".\"public\".\"Staff\"WHERE\"internal\"='f'GROUP BY\"mofo\"ORDER BY\"count\"(\"mofo\")LIMIT'1'");
			if (resultSet.next()) {
				mofo = mofoRepository.findOne(resultSet.getShort("id"));
			}
		} catch (SQLException sqlException) {
			System.err.println(getClass().getCanonicalName() + ":\n" + sqlException.getLocalizedMessage());
		} finally {
			try {
				if (connection != null) {
					if (statement != null) {
						if (resultSet != null) {
							resultSet.close();
						}
						statement.close();
					}
				}
			} catch (Exception exception) {
				System.err.println(exception.getLocalizedMessage());
			}
			resultSet = null;
			statement = null;
			connection = null;
		}
		entityManager.getTransaction().rollback();
		entityManager.close();

		/*
		 分頁
		 */
		Element elementPagination = Utils.createElementWithAttribute("pagination", documentElement, "action", request.getRequestURI());
		if (size < 1) {
			size = 10;//每頁幾筆
		}
		if (number < 0) {
			number = 0;//第幾頁
		}
		Pageable pageRequest = new PageRequest(number, size, Sort.Direction.ASC, "id");
		Page<Staff> pageOfEntities;
		if (mofo == null) {
			pageOfEntities = staffRepository.findByInternalFalseAndMofoIsNullAndRevokedFalse(pageRequest);
			elementPagination.setAttribute("mofoName", "其它");
			documentElement.setAttribute("title", "店家分類 &#187; 其它");
		} else {
			pageOfEntities = staffRepository.findByInternalFalseAndMofoAndRevokedFalse(mofo, pageRequest);
			elementPagination.setAttribute("mofoName", mofo.getName());
			documentElement.setAttribute("title", "店家分類 &#187; ".concat(mofo.getName()));
		}
		number = pageOfEntities.getNumber();
		Integer totalPages = pageOfEntities.getTotalPages();
		Long totalElements = pageOfEntities.getTotalElements();
		if (pageOfEntities.hasPrevious()) {
			elementPagination.setAttribute("previous", Integer.toString(number - 1));
			if (!pageOfEntities.isFirst()) {
				elementPagination.setAttribute("first", "0");
			}
		}
		elementPagination.setAttribute("size", size.toString());
		elementPagination.setAttribute("number", number.toString());
		for (Integer i = 0; i < totalPages; i++) {
			Element elementOption = Utils.createElementWithTextContentAndAttribute("option", elementPagination, Integer.toString(i + 1), "value", i.toString());
			if (number.equals(i)) {
				elementOption.setAttribute("selected", null);
			}
		}
		elementPagination.setAttribute("totalPages", totalPages.toString());
		elementPagination.setAttribute("totalElements", totalElements.toString());
		if (pageOfEntities.hasNext()) {
			elementPagination.setAttribute("next", Integer.toString(number + 1));
			if (!pageOfEntities.isLast()) {
				elementPagination.setAttribute("last", Integer.toString(totalPages - 1));
			}
		}

		/*
		 列表
		 */
		Element elementList = Utils.createElementWithAttribute("list", documentElement, "id", "-1");
		for (Staff entity : pageOfEntities.getContent()) {
			Utils.createElementWithTextContentAndAttribute("row", elementList, entity.getName(), "id", entity.getId().toString());
		}

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：食)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/food/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView food(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 1, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：衣)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/clothing/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView clothing(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 2, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：住)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/shelter/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView shelter(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 3, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：行)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/travel/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView travel(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 4, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：育)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/education/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView education(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 5, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：樂)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/entertainment/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView entertainment(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, (short) 6, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 列表(攤商分類：其它)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/others/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView others(@RequestParam(value = "s", defaultValue = "20") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "requestURI", request.getRequestURI());
		if (me != null) {
			documentElement.setAttribute("me", me.toString());
		}
		services.buildMofo(documentElement, null, size, number, request, session);
		services.buildFooterElement(documentElement);//底部

		ModelAndView modelAndView = new ModelAndView("mofo");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}
}
