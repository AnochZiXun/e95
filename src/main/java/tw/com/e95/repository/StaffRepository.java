package tw.com.e95.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import tw.com.e95.entity.Mofo;
import tw.com.e95.entity.Staff;

/**
 * 工作人員|攤商
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Repository
public interface StaffRepository extends JpaRepository<Staff, Integer> {

	/**
	 * @param login 帳號(電子郵件)
	 * @return 計數
	 */
	public long countByLogin(@Param("login") String login);

	/**
	 * @param login 帳號(電子郵件)
	 * @param id 主鍵
	 * @return 計數
	 */
	public long countByLoginAndIdNot(@Param("login") String login, @Param("id") Integer id);

	/**
	 * @param pageable 可分頁
	 * @return 攤商們
	 */
	public Page<Staff> findByInternalFalse(Pageable pageable);

	/**
	 * @param mofo 攤商分類
	 * @param pageable 可分頁
	 * @return 攤商們
	 */
	public Page<Staff> findByInternalFalseAndMofoAndRevokedFalse(@Param("mofo") Mofo mofo, Pageable pageable);

	/**
	 * @param pageable 可分頁
	 * @return 攤商們
	 */
	public Page<Staff> findByInternalFalseAndMofoIsNullAndRevokedFalse(Pageable pageable);

	/**
	 * @param id 主鍵
	 * @param pageable 可分頁
	 * @return 攤商們
	 */
	public Page<Staff> findByInternalTrueAndIdNot(@Param("id") Integer id, Pageable pageable);

	/**
	 * @param login 帳號(電子郵件)
	 * @return 工作人員|攤商
	 */
	public Staff findOneByLogin(@Param("login") String login);

	/**
	 * @param login login 帳號(電子郵件)
	 * @return 攤商
	 */
	public Staff findOneByLoginAndInternalFalse(@Param("login") String login);
}
