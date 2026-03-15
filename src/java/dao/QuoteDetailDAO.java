package dao;

import java.util.List;
import model.entity.QuoteDetail;

public interface QuoteDetailDAO {
    void create(QuoteDetail detail);
    List<QuoteDetail> getByQuoteId(int quoteId);
}
