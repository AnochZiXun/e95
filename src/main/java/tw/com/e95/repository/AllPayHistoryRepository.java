package tw.com.e95.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tw.com.e95.entity.AllPayHistory;

/**
 * 歐付寶支付歷程
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
public interface AllPayHistoryRepository extends JpaRepository<AllPayHistory, Long> {
}
