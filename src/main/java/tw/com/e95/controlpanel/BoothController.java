package tw.com.e95.controlpanel;

import java.io.IOException;
import java.io.StringWriter;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import static org.apache.catalina.realm.RealmBase.Digest;
import org.apache.commons.mail.EmailException;
import org.apache.commons.validator.routines.EmailValidator;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import tw.com.e95.Utils;
import tw.com.e95.entity.InternalFrame;
import tw.com.e95.entity.Merchandise;
import tw.com.e95.entity.Shelf;
import tw.com.e95.entity.Staff;
import tw.com.e95.repository.InternalFrameRepository;
import tw.com.e95.repository.MerchandiseRepository;
import tw.com.e95.repository.MofoRepository;
import tw.com.e95.repository.ShelfRepository;
import tw.com.e95.repository.StaffRepository;
import tw.com.e95.service.ControlPanelService;
import tw.com.e95.service.Services;

/**
 * 攤商
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Controller
@RequestMapping("/cPanel/booth")
public class BoothController {

	@Autowired
	private InternalFrameRepository internalFrameRepository;

	@Autowired
	private MerchandiseRepository merchandiseRepository;

	@Autowired
	private MofoRepository mofoRepository;

	@Autowired
	private ShelfRepository shelfRepository;

	@Autowired
	private StaffRepository staffRepository;

	@Autowired
	private ControlPanelService controlPanelService;

	@Autowired
	private Services services;

	/**
	 * 列表(攤商)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView welcome(@RequestParam(value = "s", defaultValue = "10") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException, SQLException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//找嘸郎
			return null;
		}

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		services.buildAsideElement(document, request);

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
		Pageable pageRequest = new PageRequest(number, size, Sort.Direction.DESC, "id");
		Page<Staff> pageOfEntities;
		pageOfEntities = staffRepository.findByInternalFalse(pageRequest);
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
		Element elementList = Utils.createElement("list", documentElement);
		for (Staff entity : pageOfEntities.getContent()) {
			String cellular = entity.getCellular(), phone = entity.getPhone(), representative = entity.getRepresentative(), address = entity.getAddress();

			Element elementRow = Utils.createElement("row", elementList);
			Utils.createElementWithTextContent("id", elementRow, entity.getId().toString());
			Utils.createElementWithTextContent("login", elementRow, entity.getLogin());
			Utils.createElementWithTextContent("name", elementRow, entity.getName());
			Utils.createElementWithTextContent("cellular", elementRow, cellular == null ? "" : cellular);
			Utils.createElementWithTextContent("phone", elementRow, phone == null ? "" : phone);
			Utils.createElementWithTextContent("representative", elementRow, representative == null ? "" : representative);
			Utils.createElementWithTextContent("address", elementRow, address == null ? "" : address);
			Utils.createElementWithTextContent("available", elementRow, Boolean.toString(entity.getShadow().matches("^[a-z0-9]{32}$")));
		}

		ModelAndView modelAndView = new ModelAndView("cPanel/booths");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 新增攤商
	 *
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/add.asp", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView add(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//找嘸郎
			return null;
		}

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		services.buildAsideElement(document, request);

		Element elementForm = Utils.createElement("form", documentElement);
		elementForm.setAttribute("action", request.getRequestURI());
		elementForm.setAttribute("legend", "新增店家");

		ModelAndView modelAndView = new ModelAndView("cPanel/addBooth");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 新增攤商
	 *
	 * @param login 店家帳號
	 * @param shadow 店家密碼
	 * @param name 店家抬頭
	 * @param mofo 店家分類
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/add.asp", produces = "text/html;charset=UTF-8", method = RequestMethod.POST)
	private ModelAndView add(@RequestParam String login, @RequestParam String shadow, @RequestParam String name, @RequestParam short mofo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException, TransformerConfigurationException, TransformerException, IOException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//找嘸郎
			return null;
		}

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		services.buildAsideElement(document, request);

		String errorMessage = null;
		Element elementForm = Utils.createElementWithAttribute("form", documentElement, "action", request.getRequestURI());

		try {
			login = login.trim().toLowerCase();
			if (login.isEmpty()) {
				throw new NullPointerException();
			}

			if (!EmailValidator.getInstance(false, false).isValid(login)) {
				errorMessage = "錯誤的帳號(電子郵件)格式！";
			}

			if (staffRepository.countByLogin(login) > 0) {
				errorMessage = "已存在的帳號(電子郵件)！";
			}
		} catch (NullPointerException nullPointerException) {
			errorMessage = "帳號(電子郵件)為必填！";
		} catch (Exception exception) {
			errorMessage = exception.getLocalizedMessage();
		}
		Utils.createElementWithTextContent("login", elementForm, login);

		try {
			if (shadow.isEmpty()) {
				throw new NullPointerException();
			}

			if (shadow.length() < 8) {
				errorMessage = "密碼必須為八碼以上！";
			}
		} catch (NullPointerException nullPointerException) {
			errorMessage = "密碼為必填！";
		} catch (Exception exception) {
			errorMessage = exception.getLocalizedMessage();
		}
		Utils.createElementWithTextContent("shadow", elementForm, shadow);

		try {
			name = name.trim();
			if (name.isEmpty()) {
				errorMessage = "店家抬頭為必填！";
			}
		} catch (Exception exception) {
			errorMessage = exception.getLocalizedMessage();
		}
		Utils.createElementWithTextContent("name", elementForm, name);

		if (errorMessage == null) {
			Staff booth = new Staff(false, login, Digest(shadow, "MD5", "UTF-8"), name);
			if (mofo != -1) {
				booth.setMofo(mofoRepository.findOne(mofo));
			}
			staffRepository.saveAndFlush(booth);

			StringWriter stringWriter = new StringWriter();
			TransformerFactory.newInstance().newTransformer(new StreamSource(getClass().getResourceAsStream("/successfulRegister.xsl"))).transform(new DOMSource(elementForm), new StreamResult(stringWriter));
			stringWriter.flush();
			stringWriter.close();
			try {
				services.buildHtmlEmail(login, "店家註冊成功通知信", stringWriter.toString()).send();
			} catch (EmailException emailException) {
				System.err.println(getClass().getCanonicalName() + ":\n" + emailException.getLocalizedMessage());
				emailException.printStackTrace(System.err);
			}

			return new ModelAndView("redirect:/cPanel/booth/");
		}
		elementForm.setAttribute("error", errorMessage);

		ModelAndView modelAndView = new ModelAndView("cPanel/addBooth");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * (停用|啟用)攤商帳號
	 *
	 * @param id 攤商的主鍵
	 * @param request
	 * @param session
	 * @return JSONObject
	 */
	@RequestMapping(value = "/{id:\\d+}/available.json", produces = "application/json;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	private String boothAbility(@PathVariable Integer id, HttpServletRequest request, HttpSession session) throws ParserConfigurationException, SQLException {
		JSONObject jsonObject = new JSONObject();
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			return jsonObject.put("reason", "一般會員無法使用！").toString();
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null || !myself.isInternal()) {
			return jsonObject.put("reason", "找不到工作人員或您為店家！").toString();
		}
		Staff booth = staffRepository.findOne(id);
		if (booth == null || booth.isInternal()) {
			return jsonObject.put("reason", "此為工作人員或找不到店家！").toString();
		}

		String shadow = booth.getShadow(), stringReversed = new StringBuilder(shadow).reverse().toString();
		boolean isAvailable = shadow.matches("^[a-z0-9]{32}$"), isRevoked = booth.isRevoked();
		booth.setShadow(isAvailable ? stringReversed.toUpperCase() : stringReversed.toLowerCase());
		booth.setRevoked(!isRevoked);//2016-03-11：停權旗標
		staffRepository.saveAndFlush(booth);

		/*
		 2016-03-11：一旦停權則旗下所有商品也下架
		 */
		if (!isAvailable && isRevoked) {
			for (Shelf shelf : shelfRepository.findByBooth(booth)) {
				for (Merchandise merchandise : merchandiseRepository.findByShelf(shelf)) {
					if (merchandise.isCarrying()) {
						merchandise.setCarrying(false);
						merchandiseRepository.saveAndFlush(merchandise);
					}
				}
			}
		}

		return jsonObject.put("response", true).toString();
	}

	/**
	 * 列表(&lt;IFRAME/&gt;)
	 *
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/internalFrame/", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView boothInternalFrames(@RequestParam(value = "s", defaultValue = "10") Integer size, @RequestParam(value = "p", defaultValue = "0") Integer number, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException, SQLException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//找嘸郎
			return null;
		}

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		services.buildAsideElement(document, request);

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
		Pageable pageRequest = new PageRequest(number, size);
		Page<InternalFrame> pageOfEntities;
		pageOfEntities = internalFrameRepository.findByBoothOrderByOrdinal(myself, pageRequest);
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
		Element elementList = Utils.createElement("list", documentElement);
		for (InternalFrame entity : pageOfEntities.getContent()) {
			Short width = entity.getWidth(), height = entity.getHeight();

			Element elementRow = Utils.createElement("row", elementList);
			Utils.createElementWithTextContent("id", elementRow, entity.getId().toString());
			Utils.createElementWithTextContent("src", elementRow, entity.getSrc());
			Utils.createElementWithTextContent("width", elementRow, width == null ? "" : width.toString());
			Utils.createElementWithTextContent("height", elementRow, height == null ? "" : height.toString());
		}

		ModelAndView modelAndView = new ModelAndView("cPanel/internalFrame/welcome");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 上移 &lt;IFRAME/&gt;
	 *
	 * @param id &lt;IFRAME/&gt; 的主鍵
	 * @param request
	 * @param session
	 * @return JSONObject
	 */
	@RequestMapping(value = "/internalFrame/{id:\\d+}/up.json", produces = "application/json;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	private String internalFrameUp(@PathVariable Long id, HttpServletRequest request, HttpSession session) throws ParserConfigurationException, SQLException {
		JSONObject jsonObject = new JSONObject();
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			return jsonObject.put("reason", "一般會員無法使用！").toString();
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null || myself.isInternal()) {
			return jsonObject.put("reason", "找不到店家或您為工作人員！").toString();
		}
		InternalFrame internalFrame = internalFrameRepository.findOne(id);
		if (internalFrame == null) {
			return jsonObject.put("reason", "找不到 &lt;IFRAME/&gt;！").toString();
		}

		controlPanelService.sortInternalFrameByBooth(myself);
		if (internalFrame.getOrdinal() == 1) {
			return jsonObject.put("reason", "已達頂端！").toString();
		}

		short ordinal = internalFrame.getOrdinal();
		InternalFrame previousinternalFrame = internalFrameRepository.findOneByBoothAndOrdinal(myself, Integer.valueOf(ordinal - 1).shortValue());
		short previousOrdinal = previousinternalFrame.getOrdinal();

		internalFrame.setOrdinal((short) -1);
		internalFrameRepository.saveAndFlush(internalFrame);

		previousinternalFrame.setOrdinal(ordinal);
		internalFrameRepository.saveAndFlush(previousinternalFrame);

		internalFrame.setOrdinal(previousOrdinal);
		internalFrameRepository.saveAndFlush(internalFrame);

		controlPanelService.sortInternalFrameByBooth(myself);
		return jsonObject.put("response", true).toString();
	}

	/**
	 * 下移 &lt;IFRAME/&gt;
	 *
	 * @param id &lt;IFRAME/&gt; 的主鍵
	 * @param request
	 * @param session
	 * @return JSONObject
	 */
	@RequestMapping(value = "/internalFrame/{id:\\d+}/down.json", produces = "application/json;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	private String internalFrameDown(@PathVariable Long id, HttpServletRequest request, HttpSession session) throws ParserConfigurationException, SQLException {
		JSONObject jsonObject = new JSONObject();
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			return jsonObject.put("reason", "一般會員無法使用！").toString();
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null || myself.isInternal()) {
			return jsonObject.put("reason", "找不到店家或您為工作人員！").toString();
		}
		InternalFrame internalFrame = internalFrameRepository.findOne(id);
		if (internalFrame == null) {
			return jsonObject.put("reason", "找不到 &lt;IFRAME/&gt;！").toString();
		}

		controlPanelService.sortInternalFrameByBooth(myself);
		if (internalFrame.getOrdinal() >= internalFrameRepository.countByBooth(myself)) {
			return jsonObject.put("reason", "已達底端！").toString();
		}

		short ordinal = internalFrame.getOrdinal();
		InternalFrame nextinternalFrame = internalFrameRepository.findOneByBoothAndOrdinal(myself, Integer.valueOf(ordinal + 1).shortValue());
		short nextOrdinal = nextinternalFrame.getOrdinal();

		internalFrame.setOrdinal((short) -1);
		internalFrameRepository.saveAndFlush(internalFrame);

		nextinternalFrame.setOrdinal(ordinal);
		internalFrameRepository.saveAndFlush(nextinternalFrame);

		internalFrame.setOrdinal(nextOrdinal);
		internalFrameRepository.saveAndFlush(internalFrame);

		controlPanelService.sortInternalFrameByBooth(myself);
		return jsonObject.put("response", true).toString();
	}

	/**
	 * 新增 &lt;IFRAME/&gt;
	 *
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/internalFrame/add.asp", produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
	private ModelAndView createInternalFrame(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException, SQLException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null || myself.isInternal()) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止工作人員存取
			return null;
		}
		String requestURI = request.getRequestURI();

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		documentElement.setAttribute("requestURI", requestURI);
		services.buildAsideElement(document, request);

		Element elementForm = Utils.createElementWithAttribute("form", documentElement, "action", requestURI);
		elementForm.setAttribute("legend", "新增 &#60;IFRAME&#47;&#62;");
		controlPanelService.loadInternalFrame(new InternalFrame(), elementForm);

		ModelAndView modelAndView = new ModelAndView("cPanel/internalFrame/form");
		modelAndView.getModelMap().addAttribute(new DOMSource(document));
		return modelAndView;
	}

	/**
	 * 新增 &lt;IFRAME/&gt;
	 *
	 * @param src address of the resource
	 * @param width horizontal dimension
	 * @param height vertical dimension
	 * @param request
	 * @param response
	 * @param session
	 * @return 網頁
	 */
	@RequestMapping(value = "/internalFrame/add.asp", produces = "text/html;charset=UTF-8", method = RequestMethod.POST)
	private ModelAndView createInternalFrame(@RequestParam String src, @RequestParam Short width, @RequestParam Short height, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ParserConfigurationException, SQLException {
		Integer me = (Integer) session.getAttribute("me");
		if (me != null) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止會員存取
			return null;
		}
		Staff myself = staffRepository.findOneByLogin(request.getRemoteUser());
		if (myself == null || myself.isInternal()) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);//禁止工作人員存取
			return null;
		}
		String requestURI = request.getRequestURI();

		Document document = Utils.newDocument();
		Element documentElement = Utils.createElementWithAttribute("document", document, "internal", Boolean.toString(myself.isInternal()));
		documentElement.setAttribute("requestURI", requestURI);
		services.buildAsideElement(document, request);

		Element elementForm = Utils.createElementWithAttribute("form", documentElement, "action", requestURI);
		elementForm.setAttribute("legend", "新增 &#60;IFRAME&#47;&#62;");
		String errorMessage = controlPanelService.saveInternalFrame(new InternalFrame(), myself, src, width, height, elementForm);
		if (errorMessage != null) {
			elementForm.setAttribute("error", errorMessage);

			ModelAndView modelAndView = new ModelAndView("cPanel/internalFrame/form");
			modelAndView.getModelMap().addAttribute(new DOMSource(document));
			return modelAndView;
		}

		return new ModelAndView("redirect:/cPanel/booth/internalFrame/");
	}
}
