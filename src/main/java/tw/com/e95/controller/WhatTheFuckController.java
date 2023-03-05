package tw.com.e95.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import javax.imageio.ImageIO;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import tw.com.e95.Utils;
import tw.com.e95.entity.MerchandiseImage;
import tw.com.e95.repository.MerchandiseImageRepository;

/**
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Controller
@RequestMapping("/whatTheFuck")
public class WhatTheFuckController {

	private final DecimalFormat decimalFormat = new DecimalFormat("000,000");

	@Autowired
	private MerchandiseImageRepository merchandiseImageRepository;

	@PersistenceUnit
	private EntityManagerFactory entityManagerFactory;

	@RequestMapping(value = "/", produces = "text/plain;charset=UTF-8", method = RequestMethod.GET)
	@ResponseBody
	@SuppressWarnings("ConvertToTryWithResources")
	private String welcome() throws IOException {
		StringBuilder stringBuilder = new StringBuilder();
		EntityManager entityManager = entityManagerFactory.createEntityManager();

		entityManager.getTransaction().begin();
		Connection connection = entityManager.unwrap(java.sql.Connection.class);
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery("SELECT\"id\"FROM\"e95Mall\".\"public\".\"MerchandiseImage\"WHERE\"length\"(\"content\")>'524288'ORDER BY\"id\"");
			while (resultSet.next()) {
				Long id = resultSet.getLong("id");
				stringBuilder.append(id);
				MerchandiseImage merchandiseImage = merchandiseImageRepository.findOne(id);
				byte[] content = merchandiseImage.getContent();

				BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(content));
				int width = bufferedImage.getWidth(), height = bufferedImage.getHeight();

				if (width > 389 && height > 389) {
					ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
					ImageIO.write(Utils.rescaleImage(content, 389, 389), "PNG", byteArrayOutputStream);
					byteArrayOutputStream.flush();
					byte[] byteArray = byteArrayOutputStream.toByteArray();
					merchandiseImage.setContent(byteArray);
					merchandiseImageRepository.saveAndFlush(merchandiseImage);
					byteArrayOutputStream.close();

					stringBuilder.append("\t").append(decimalFormat.format(content.length)).append(":").append(decimalFormat.format(byteArray.length)).append("\t").append((float) byteArray.length / (float) content.length);
				}

				stringBuilder.append("\n");
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
		return stringBuilder.toString();
	}
}
