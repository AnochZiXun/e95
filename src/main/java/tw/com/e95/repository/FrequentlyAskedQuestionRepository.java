package tw.com.e95.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import tw.com.e95.entity.FrequentlyAskedQuestion;

/**
 * 常見問答
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Repository
public interface FrequentlyAskedQuestionRepository extends JpaRepository<FrequentlyAskedQuestion, Short>, JpaSpecificationExecutor<FrequentlyAskedQuestion> {
}
