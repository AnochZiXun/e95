package tw.com.e95.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import tw.com.e95.Utils;
import tw.com.e95.entity.Accordion;
import tw.com.e95.entity.Mofo;
import tw.com.e95.entity.Staff;
import tw.com.e95.repository.AccordionRepository;
import tw.com.e95.repository.MofoRepository;
import tw.com.e95.repository.StaffRepository;

/**
 * 共用服務層
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Service
public class Services {

	@Autowired
	private AccordionRepository accordionRepository;

	@Autowired
	private MofoRepository mofoRepository;

	@Autowired
	private StaffRepository staffRepository;

	@PersistenceUnit
	private EntityManagerFactory entityManagerFactory;

	/**
	 * 打造控制臺的手風琴(側邊選單)
	 *
	 * @param document 整份 XML 文件
	 * @param request
	 * @return 手風琴(側邊選單) element
	 */
	public Element buildAsideElement(Document document, HttpServletRequest request) {
		Staff me = staffRepository.findOneByLogin(request.getRemoteUser());
		boolean isInternal = me.isInternal();

		Element documentElement = document.getDocumentElement();
		documentElement.setAttribute("me", staffRepository.findOneByLogin(request.getRemoteUser()).getName());

		String requestURI = request.getRequestURI().replaceAll("^".concat("/cPanel/"), "");
		Element asideElement = Utils.createElement("aside", documentElement);
		for (Accordion accordionHeader : accordionRepository.findByParentNullOrderByOrdinal()) {
			if (isInternal == accordionHeader.isInternal()) {
				Element headerElement = Utils.createElementWithAttribute("collapsed", asideElement, "name", accordionHeader.getName());
				for (Accordion accordion : accordionRepository.findByParentOrderByOrdinal(accordionHeader)) {
					if (isInternal == accordion.isInternal()) {
						String fragment = accordion.getFragment();
						Utils.createElementWithTextContentAndAttribute("anchor", headerElement, accordion.getName(), "href", fragment);
						if (requestURI.matches("^".concat(fragment.replaceAll("/", "\\\\/.*")))) {
							document.renameNode(headerElement, headerElement.getNamespaceURI(), "expanded");
						}
					}
				}
			}
		}
		return asideElement;
	}

	/**
	 * 打造前臺的底部
	 *
	 * @param documentElement 根 element
	 */
	public void buildFooterElement(Element documentElement) {
		Element elementBooths = Utils.createElement("booths", documentElement);
		EntityManager entityManager = entityManagerFactory.createEntityManager();

		entityManager.getTransaction().begin();
		Connection connection = entityManager.unwrap(java.sql.Connection.class);
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery("SELECT\"id\"FROM\"e95Mall\".\"public\".\"Staff\"WHERE\"internal\"='f'AND\"logo\"IS NOT NULL AND\"revoked\"='f'ORDER BY\"random\"()LIMIT'8'");
			while (resultSet.next()) {
				Staff booth = staffRepository.findOne(resultSet.getInt("id"));

				Element elementBooth = Utils.createElement("booth", elementBooths);
				Utils.createElementWithTextContent("id", elementBooth, booth.getId().toString());
				Utils.createElementWithTextContent("name", elementBooth, booth.getName());
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
					//connection.close();
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
	}

	/**
	 * 打造格式化的電子郵件
	 *
	 * @param email 收件者的信箱位址
	 * @param subject 主旨
	 * @param html 內容
	 * @return HtmlEmail
	 */
	public HtmlEmail buildHtmlEmail(String email, String subject, String html) {
		HtmlEmail htmlEmail = new HtmlEmail();
		try {
			ResourceBundle resourceBundle = ResourceBundle.getBundle("smtp");

			htmlEmail.setHostName(resourceBundle.getString("hostName"));
			htmlEmail.setSmtpPort(465);
			htmlEmail.setAuthentication(resourceBundle.getString("userName"), resourceBundle.getString("password"));
			htmlEmail.setSSLOnConnect(true);
			htmlEmail.setCharset("UTF-8");
			htmlEmail.setFrom(resourceBundle.getString("fromAddress"), resourceBundle.getString("fromName"), "UTF-8");
			htmlEmail.addTo(email);
			htmlEmail.setSubject(subject);
			htmlEmail.setHtmlMsg(html);
		} catch (EmailException emailException) {
			System.err.println(getClass().getCanonicalName() + ":\n" + emailException.getLocalizedMessage());
		}
		return htmlEmail;
	}

	/**
	 * 打造格式化的電子郵件
	 *
	 * @param to 收件者的信箱位址
	 * @param cc 副本收件者的信箱位址
	 * @param subject 主旨
	 * @param html 內容
	 * @return HtmlEmail
	 */
	public HtmlEmail buildHtmlEmail(String to, String cc, String subject, String html) {
		HtmlEmail htmlEmail = new HtmlEmail();
		try {
			ResourceBundle resourceBundle = ResourceBundle.getBundle("smtp");

			htmlEmail.setHostName(resourceBundle.getString("hostName"));
			htmlEmail.setSmtpPort(465);
			htmlEmail.setAuthentication(resourceBundle.getString("userName"), resourceBundle.getString("password"));
			htmlEmail.setSSLOnConnect(true);
			htmlEmail.setCharset("UTF-8");
			htmlEmail.setFrom(resourceBundle.getString("fromAddress"), resourceBundle.getString("fromName"), "UTF-8");
			htmlEmail.addTo(to);
			htmlEmail.addCc(cc);
			htmlEmail.setSubject(subject);
			htmlEmail.setHtmlMsg(html);
		} catch (EmailException emailException) {
			System.err.println(getClass().getCanonicalName() + ":\n" + emailException.getLocalizedMessage());
		}
		return htmlEmail;
	}

	/**
	 * 攤商分類
	 *
	 * @param documentElement 根 element
	 * @param mofoId 攤商分類的主鍵
	 * @param size 每頁幾筆
	 * @param number 第幾頁
	 * @param request
	 * @param session
	 */
	public void buildMofo(Element documentElement, Short mofoId, Integer size, Integer number, HttpServletRequest request, HttpSession session) {
		/*
		 分頁
		 */
		Mofo mofo = mofoId == null ? null : mofoRepository.findOne((short) mofoId);
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
		Element elementList = Utils.createElementWithAttribute("list", documentElement, "id", mofo == null ? "-1" : mofoId.toString());
		for (Staff entity : pageOfEntities.getContent()) {
			Utils.createElementWithTextContentAndAttribute("row", elementList, entity.getName(), "id", entity.getId().toString());
		}
	}
}
